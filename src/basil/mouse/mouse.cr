module Basil::Mouse::Mouse
  @@scroll = new Scroll.new
  @@buttons = {} of UInt8 => Click
  @@pos = Vec2(Int32).new(0,0)
  @@scrolling = false

  def buttons
    @@buttons
  end

  def pos
    @@pos
  end

  # TODO: scroll events
  def scrolling?
    @@scrolling
  end

  def update
    @@buttons.each do |i, button|
      button.update
    end
    @@scroll.update
  end

  def update(event : SDL::Event::MouseButton)
    if event.type.to_s.downcase.ends_with? "down"
      # first press of button, click objects created
      first_pressed = !@@buttons[event.button]?

      if first_pressed
        click = Click.new event, first_pressed
        @@buttons[event.button] = click
      else
        @@buttons[event.button].update event
      end
    end
  end

  def cursor=(show : Bool)
    if show
      LibSDL.show_cursor(1)
    else
      LibSDL.show_cursor(0)
    end
  end

  # reset cursor
  def cursor=(n : Nil)
    self.cursor = LibSDL.create_system_cursor(LibSDL::SystemCursor::ARROW)
  end

  # mouse input delay?
  def cursor=(n : String)
    case n
    when "reset"
      cursor_name = LibSDL::SystemCursor::ARROW
    when .starts_with? "point" || "hand"
      cursor_name = LibSDL::SystemCursor::HAND
    when "edit"
      cursor_name = LibSDL::SystemCursor::IBEAM
    when .starts_with? "load" || "wait"
      cursor_name = LibSDL::SystemCursor::WAIT
    when "crosshair"
      cursor_name = LibSDL::SystemCursor::CROSSHAIR
    when "nwse" || "sizenwse"
      cursor_name = LibSDL::SystemCursor::SIZENWSE
    when "nesw" || "sizenesw"
      cursor_name = LibSDL::SystemCursor::SIZENESW
    when "we" || "sizewe"
      cursor_name = LibSDL::SystemCursor::SIZEWE
    when "ns" || "sizens"
      cursor_name = LibSDL::SystemCursor::SIZENS
    when "all" || "sizeall"
      cursor_name = LibSDL::SystemCursor::SIZEALL
    when "no"
      cursor_name = LibSDL::SystemCursor::NO
    else
      cursor_name = LibSDL::SystemCursor.parse(n)
    end

    self.cursor = LibSDL.create_system_cursor(cursor_name)
  end
  
  def cursor=(cursor : Pointer(LibSDL::Cursor))
    LibSDL.set_cursor cursor
  end

  def update(event : SDL::Event::MouseWheel)
    @@scroll.update event
  end

  def primary; @@buttons[1_u8]?
  def secondary; @@buttons[3_u8]?
  def middle; @@button[2u8]?

  def button(id : UInt8)
    @@buttons[id]?
  end

  def scroll
    @@scroll
  end
end