require "sinatra"
require "mini_magick"

MiniMagick.logger.level = Logger::DEBUG

ROOT = ENV["ROOT"]
KEY = ENV["KEY"]

FileUtils.mkdir_p "tmp"

get "/*" do |path|
  filename = File.basename(path)
  geometry = params["geo"]

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

  MiniMagick::Tool::Magick.new do |magick|
    magick << @decrypted.path
    magick.resize "#{geometry}^"
    magick.gravity "center"
    magick.extent geometry
    magick.ordered_dither "o8x8"
    magick.monochrome
    magick << @dithered.path
  end

  content_type "image/png"
  File.open(@dithered.path)
end
