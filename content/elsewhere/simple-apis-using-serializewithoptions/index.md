---
title: "Simple APIs using SerializeWithOptions"
date: 2009-07-09T00:00:00+00:00
draft: false
canonical_url: https://www.viget.com/articles/simple-apis-using-serializewithoptions/
---

While we were creating the [SpeakerRate
API](http://speakerrate.com/api), we noticed that ActiveRecord's
serialization system, while expressive, requires entirely too much
repetition. As an example, keeping a speaker's email address out of an
API response is simple enough:

```ruby
@speaker.to_xml(:except => :email)
```

But if we want to include speaker information in a talk response, we
have to exclude the email attribute again:

```ruby
@talk.to_xml(:include => { :speakers => { :except => :email } })
```

Then imagine that a talk has a set of additional directives, and the API
responses for events and series include lists of talks, and you can see
how our implementation quickly turned into dozens of lines of repetitive
code strewn across several controllers. We figured there had to be a
better way, so when we couldn't find one, we created [SerializeWithOptions](https://github.com/vigetlabs/serialize_with_options). 

At its core, SerializeWithOptions is a simple DSL for describing how to
turn an ActiveRecord object into XML or JSON. To use it, put
a `serialize_with_options` block in your model, like so:

```ruby
class Speaker < ActiveRecord::Base
  # ...
  serialize_with_options do
    methods :average_rating, :avatar_url
    except :email, :claim_code
    includes :talks
  end
  # ...
end

class Talk < ActiveRecord::Base
  # ...
  serialize_with_options do
    methods :average_rating
    except :creator_id
    includes :speakers, :event, :series
  end
  # ...
end
```

With this configuration in place, calling `@speaker.to_xml` is the same
as calling:

```ruby
@speaker.to_xml(
  :methods => [:average_rating, :avatar:url],
  :except => [:email, :claim_code],
  :include => {
    :talks => {
      :methods => :average_rating,
      :except => :creator_id
    }
  }
)
```

Once you've defined your serialization options, your controllers will
end up looking like this:

```ruby
def show
  @post = Post.find(params[:id]) respond_to do |format|
    format.html
    format.xml { render :xml => @post }
    format.json { render :json => @post }
  end
end
```

Source code and installation instructions are available on GitHub. We
hope this can help you DRY up your app's API, or, if it doesn't have
one, remove your last excuse.

**UPDATE 6/14:** We've added a few new features to SerializeWithOptions
to handle some real-world scenarios we've encountered. You can now
specify multiple `serialize_with_options` blocks:

```ruby
class Speaker < ActiveRecord::Base
  # ...
  serialize_with_options do
    methods :average_rating, :avatar_url
    except :email, :claim_code
    includes :talks
  end

  serialize_with_options :with_email do
    methods :average_rating, :avatar_url
    except :claim_code
    includes :talks
  end
  # ...
end
```

You can now call `@speaker.to_xml` and get the default options, or
`@speaker.to_xml(:with_email)` for the second set. When pulling in
nested models, SerializeWithOptions will use configuration blocks with
the same name if available, otherwise it will use the default.

Additionally, you can now pass a hash to `:includes` to set a custom
configuration for included models

```ruby
class Speaker < ActiveRecord::Base
  # ...
  serialize_with_options do
    methods :average_rating, :avatar_url
    except :email, :claim_code
    includes :talks => { :include => :comments }
  end
  # ...
end
```

Use this method if you want to nest multiple levels of models or
overwrite other settings.
