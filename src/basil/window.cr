class Leafgem::Window
  property window : SDL::Window
  property size = Vec2(Int32).new 0,0

  def initialize(title, w, h, resize, fullscreen = False)
    @window = SDL::Window.new(
      title, w, h,
      LibSDL::WindowPosition::UNDEFINED, LibSDL::WindowPosition::UNDEFINED,
      (resize) ? LibSDL::WindowFlags::RESIZABLE
      : (fullscreen) ? LibSDL::WindowFlags::FULLSCREEN
      : LiBSDL::WindowFlags::SHOWN
    )

    @size = Vec2.from w h
  end

  def destroy
    window.finalize
  end

  def current_size
    cr_w = 0
    cr_h = 0
    LibSDL.get_window_size(@window, pointerof(cr_w), pointerof(cr_h))
    Vec2.from cr_w, cr_h
  end
end
