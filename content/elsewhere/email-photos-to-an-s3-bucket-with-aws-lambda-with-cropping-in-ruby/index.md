---
title: "Email Photos to an S3 Bucket with AWS Lambda (with Cropping, in Ruby)"
date: 2021-04-07T00:00:00+00:00
draft: false
needs_review: true
canonical_url: https://www.viget.com/articles/email-photos-to-an-s3-bucket-with-aws-lambda-with-cropping-in-ruby/
---

In my annual search for holiday gifts, I came across this [digital photo
frame](https://auraframes.com/digital-frames/color/graphite) that lets
you load photos via email. Pretty neat, but I ultimately didn\'t buy it
for a few reason: 1) it\'s pretty expensive, 2) I\'d be trusting my
family\'s data to an unknown entity, and 3) if the company ever goes
under or just decides to stop supporting the product, it might stop
working or at least stop updating. But I got to thinking, could I build
something like this myself? I\'ll save the full details for a later
article, but the first thing I needed to figure out was how to get
photos from an email into an S3 bucket that could be synced onto a
device.

I try to keep up with the various AWS offerings, and Lambda has been on
my radar for a few years, but I haven\'t had the opportunity to use it
in anger. Services like this really excel at the extremes of web
software --- at the low end, where you don\'t want to incur the costs of
an always-on server, and at the high-end, where you don\'t want to pay
for a whole fleet of them. Most of our work falls in the middle, where
developer time is way more costly than hosting infrastructure and so
using a more full-featured stack running on a handful of conventional
servers is usually the best option. But an email-to-S3 gateway is a
perfect use case for on-demand computing.

[]{#the-services}

## The Services [\#](#the-services "Direct link to The Services"){.anchor aria-label="Direct link to The Services"}

To make this work, we need to connect several AWS services:

-   [Route 53](https://aws.amazon.com/route53/) (for domain registration
    and DNS configuration)
-   [SES](https://aws.amazon.com/ses/) (for setting up the email address
    and \"rule set\" that triggers the Lambda function)
-   [S3](https://aws.amazon.com/s3/) (for storing the contents of the
    incoming emails as well as the resulting photos)
-   [SNS](https://aws.amazon.com/sns/) (for notifying the Lambda
    function of an incoming email)
-   [Lambda](https://aws.amazon.com/lambda) (to process the incoming
    email, extract the photos, crop them, and store the results)
-   [CloudWatch](https://aws.amazon.com/cloudwatch) (for debugging
    issues with the code)
-   [IAM](https://aws.amazon.com/iam) (for setting the appropriate
    permissions)

It\'s a lot, to be sure, but it comes together pretty easily:

1.  Create a couple buckets in S3, one to hold emails, the other to hold
    photos.
2.  Register a domain (\"hosted zone\") in Route 53.
3.  Go to Simple Email Service \> Domains and verify a new domain,
    selecting the domain you just registered in Route 53.
4.  Go to the SES \"rule sets\" interface and click \"Create Rule.\"
    Give it a name and an email address you want to send your photos to.
5.  For the rule action, pick \"S3\" and then the email bucket you
    created in step 1 (we have to use S3 rather than just calling the
    Lambda function directly because our emails exceed the maximum
    payload size). Make sure to add an SNS (Simple Notification Service)
    topic to go along with your S3 action, which is how we\'ll trigger
    our Lambda function.
6.  Go to the Lambda interface and create a new function. Give it a name
    that makes sense for you and pick Ruby 2.7 as the language.
7.  With your skeleton function created, click \"Add Trigger\" and
    select the SNS topic you created in step 5. You\'ll need to add
    ImageMagick as a layer[^1^](#fn1){#fnref1 .footnote-ref
    role="doc-noteref"} and bump the memory and timeout (I used 512 MB
    and 30 seconds, respectively, but you should use whatever makes you
    feel good in your heart).
8.  Create a couple environment variables: `BUCKET` should be name of
    the S3 bucket you want to upload photos to, and `AUTHORIZED_EMAILS`
    to hold all the valid email addresses separated by semicolons.
9.  Give your function permissions to read and write to/from the two
    buckets.
10. And finally, the code. We\'ll manage that locally rather than using
    the web-based interface since we need to include a couple gems.

[]{#the-code}

## The Code [\#](#the-code "Direct link to The Code"){.anchor aria-label="Direct link to The Code"}

So as I said literally one sentence ago, we manage the code for this
Lambda function locally since we need to include a couple gems:
[`mail`](https://github.com/mikel/mail) to parse the emails stored in S3
and [`mini_magick`](https://github.com/minimagick/minimagick) to do the
cropping. If you don\'t need cropping, feel free to leave that one out
and update the code accordingly. Without further ado:

``` {.code-block .line-numbers}
require 'json'
require 'aws-sdk-s3'
require 'mail'
require 'mini_magick'

BUCKET = ENV["BUCKET"]
AUTHORIZED_EMAILS = ENV["AUTHORIZED_EMAILS"].split(";")

def lambda_handler(event:, context:)
  message = JSON.parse(event["Records"][0]["Sns"]["Message"])
  s3_info = message["receipt"]["action"]
  client = Aws::S3::Client.new(region: "us-east-1")

  # Get the incoming email from S3
  object = client.get_object(
    bucket: s3_info["bucketName"],
    key: s3_info["objectKey"]
  )

  email = Mail.new(object.body.read)
  sender = email.from.first

  # Confirm that the sender is in the list, otherwise abort
  unless AUTHORIZED_EMAILS.include?(sender)
    puts "Unauthorized email: #{sender}"
    exit
  end

  # Get all the images out of the email
  attachments = email.parts.filter { |p| p.content_type =~ /^image/ }

  attachments.each do |attachment|
    # First, just put the original photo in the `photos` subdirectory
    client.put_object(
      body: attachment.body.to_s,
      bucket: BUCKET,
      key: "photos/#{attachment.filename}"
    )

    thumb = MiniMagick::Image.read(attachment.body.to_s)

    # Crop the photo down for displaying on a webpage
    thumb.combine_options do |i|
      i.auto_orient
      i.resize "440x264^"
      i.gravity "center"
      i.extent "440x264"
    end

    client.put_object(
      body: thumb.to_blob,
      bucket: BUCKET,
      key: "thumbs/#{attachment.filename}"
    )

    dithered = MiniMagick::Image.read(attachment.body.to_s)

    # Crop and dither the photo for displaying on an e-ink screen
    dithered.combine_options do |i|
      i.auto_orient
      i.resize "880x528^"
      i.gravity "center"
      i.extent "880x528"
      i.ordered_dither "o8x8"
      i.monochrome
    end

    client.put_object(
      body: dithered.to_blob,
      bucket: BUCKET,
      key: "dithered/#{attachment.filename}"
    )

    puts "Photo '#{attachment.filename}' uploaded"
  end

  {
    statusCode: 200,
    body: JSON.generate("#{attachments.size} photo(s) uploaded.")
  }
end
```

If you\'re unfamiliar with dithering, [here\'s a great
post](https://surma.dev/things/ditherpunk/) with more info, but in
short, it\'s a way to simulate grayscale with only black and white
pixels like what you find on an e-ink/e-paper display.

[]{#deploying}

## Deploying [\#](#deploying "Direct link to Deploying"){.anchor aria-label="Direct link to Deploying"}

To deploy your code, you\'ll use the [AWS
CLI](https://aws.amazon.com/cli/). [Here\'s a pretty good
walkthrough](https://docs.aws.amazon.com/lambda/latest/dg/ruby-package.html)
of how to do it but I\'ll summarize:

1.  Install your gems locally with
    `bundle install --path vendor/bundle`.
2.  Edit your code (in our case, it lives in `lambda_function.rb`).
3.  Make a simple shell script that zips up your function and gems and
    sends it up to AWS:

``` {.code-block .line-numbers}
#!/bin/sh

zip -r function.zip lambda_function.rb vendor 
  && aws lambda update-function-code 
  --function-name [lambda-function-name] 
  --zip-file fileb://function.zip
```

And that\'s it! A simple, resilient, cheap way to email photos into an
S3 bucket with no servers in sight (at least none you care about or have
to manage).

------------------------------------------------------------------------

In closing, this project was a great way to get familiar with Lambda and
the wider AWS ecosystem. It came together in just a few hours and is
still going strong several months later. My typical bill is something on
the order of \$0.50 per month. If anything goes wrong, I can pop into
CloudWatch to view the result of the function, but so far, [so
smooth](https://static.viget.com/DP823L7XkAIJ_xK.jpg).

I\'ll be back in a few weeks detailing the rest of the project. Stay
tuned!


------------------------------------------------------------------------

1.  ::: {#fn1}
    I used the ARN
    `arn:aws:lambda:us-east-1:182378087270:layer:image-magick:1`[↩︎](#fnref1){.footnote-back
    role="doc-backlink"}
    :::
