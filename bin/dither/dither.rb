require "sinatra"
require "mini_magick"

MiniMagick.logger.level = Logger::DEBUG

ROOT = ENV.fetch("ROOT")
KEY = ENV.fetch("KEY")
DITHER = ENV["DITHER"] != "0"
FORMAT = DITHER ? "png" : "webp"

get "/*" do |path|
  content_type "image/#{FORMAT}"

  geometry = params["geo"] unless params["geo"] == ""

  decrypted = %x(
    openssl \
      aes-256-cbc \
      -d \
      -in #{ROOT}/#{path}.enc \
      -pass file:#{KEY} \
      -iter 1000000
  )

  convert = MiniMagick::Tool::Convert.new
  convert.stdin
  convert.background("white")
  convert.layers("flatten")

  if geometry
    if geometry.match?(/^\d+x\d+$/)
      convert.resize "#{geometry}^"
      convert.gravity "center"
      convert.extent geometry
    else
      convert.resize geometry
    end
  end

  if DITHER
    convert.ordered_dither "o8x8"
    convert.monochrome
  end

  convert << "#{FORMAT.upcase}:-"
  convert.call(stdin: decrypted)
end
