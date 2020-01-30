module Basil::Mouse::Mouse
  @@scroll = new Scroll.new
  @@buttons = {} of UInt8 => Click
  @@pos = Vec2(Int32).new(0,0)
  @@scrolling = false
end