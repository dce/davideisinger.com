require "sinatra"
require "mini_magick"

MiniMagick.logger.level = Logger::DEBUG

ROOT = ENV["ROOT"]
KEY = ENV["KEY"]

FileUtils.mkdir_p "tmp"

get "/*" do |path|
  filename = File.basename(path)
  geometry = params["geo"] unless params["geo"] == ""

  @decrypted = Tempfile.new(filename, "tmp")
  @dithered = Tempfile.new([filename, ".png"], "tmp")

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

  if geometry
    convert.resize "#{geometry}^"
    convert.gravity "center"
    convert.extent geometry
  end

  convert.ordered_dither "o8x8"
  convert.monochrome
  convert << @dithered.path
  convert.call

  content_type "image/png"
  File.open(@dithered.path)
end
