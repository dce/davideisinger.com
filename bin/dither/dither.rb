require "sinatra"
require "mini_magick"

MiniMagick.logger.level = Logger::DEBUG

ROOT = ENV.fetch("ROOT")
KEY = ENV.fetch("KEY")
DITHER = ENV["DITHER"] != "0"

EXTENSION, CONTENT_TYPE = if DITHER
  [".png", "image/png"]
else
  [".webp", "image/webp"]
end

FileUtils.mkdir_p "tmp"

get "/*" do |path|
  filename = File.basename(path)
  geometry = params["geo"] unless params["geo"] == ""

  @decrypted = Tempfile.new(filename, "tmp")
  @dithered = Tempfile.new([filename, EXTENSION], "tmp")

  %x(
    openssl \
      aes-256-cbc \
      -d \
      -in #{ROOT}/#{path}.enc \
      -out #{@decrypted.path} \
      -pass file:#{KEY} \
      -iter 1000000
  )

  convert = MiniMagick::Tool::Convert.new
  convert << @decrypted.path
  convert.background("white")
  convert.layers("flatten")

  if geometry
    if geometry.start_with?("x") || geometry.end_with?("x")
      convert.resize geometry
    else
      convert.resize "#{geometry}^"
      convert.gravity "center"
      convert.extent geometry
    end
  end

  if DITHER
    convert.ordered_dither "o8x8"
    convert.monochrome
  end

  convert << @dithered.path
  convert.call

  content_type CONTENT_TYPE
  File.open(@dithered.path)
end
