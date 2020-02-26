class Basil::Mouse::Click
  property pos : Vec2(Int32)
  property event : SDL::Event::MouseButton?
  property held : Bool

  # TODO: Update `#held?` and `#pressed?` automatically
  def initialize(@event, @pressed = true)
    @pos = Vec2.from @event.x, @event.y
    @held = !@pressed
    # @when_pressed = event.timestamp
  end
  
  def held?
    @held
  end

  def pressed?
    @pressed
  end

  def update
    @pressed = false
    @held = !@pressed
  end

  def update(@event, @pressed = false)
    @pos = Vec2.from @event.x, @event.y
    @held = !@pressed
  end
end