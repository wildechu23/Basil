# TODO: Write documentation for `Basil`
require "sdl"
require "sdl/image"
require "sdl/mix"

SDL.init(SDL::Init::VIDEO | SDL::Init::AUDIO); at_exit { SDL.quit }
SDL::IMG.init(SDL::IMG::Init::PNG); at_exit { SDL::IMG.quit }
SDL::Mix.open

require "./basil/**"
include Basil::Util

module Basil
  VERSION = "0.1.0"

  # TODO: Put your code here
end
