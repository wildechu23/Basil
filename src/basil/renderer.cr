module Basil::Renderer
  @@fps = 60
  @@renderer : SDL::Renderer?
  @@window : SDL::Window?

  @@camera = Basil::Camera.new

  @@scale = 1

  @@size = Vec2(Int32).new 0, 0
  @@offset = Vec2(Int32).new 0,0

  @@screen_surface : SDL::Surface?
  @@screen_surface_pointer : Pointer(LibSDL::Surface)?

  @@background_color = SDL::Color.new(255,255,255)

  def create(title : String, width : Int32, height : Int32, pixel_scale : Float32)
    #check for window
    if (@@window == nil)
      make_window(title, width, height, pixel_scale)
    end
  end

  def make_window(title : String, width : Int32, height : Int32, pixel_scale : Float32)
    @@window = Basil::Window.new(title, height, width, true)
    @@scale = pixel_scale
    @@size = Vec2.from(width/pixel_scale, height/pixel_scale).to_i

    @@screen_surface_pointer = LibSDL.create_rgb_surface(0, @@size.x, @@size.y, 32, 0, 0, 0, 0)
    if (ssp = screen_surface_pointer)
      @@screen_surface = SDL::Surface.new(ssp)
    end
    if (window = @@window)
      @@renderer = SDL::Renderer.new(window.window, SDL::Renderer::Flags::ACCELERATED)
      if (renderer = @@renderer)
        renderer.draw_blend_mode = LibSDL::BlendMode::BLEND
      end
    end
  end

  def clear_screen(r,g,b)
    #change color for clear, then change back
    if (ba_r = Basil::Renderer.renderer)
      old_color = ba_r.draw_color
      ba_r.draw_color = SDL::Color[r,g,b,255]
      ba_r.clear
      ba_r.draw_color = old_color
    end
    #fill background color
    if (surf = Basil::Renderer.surface)
      surf.fill(@@background_color.r, @@background_color.g, @@background_color.b)
    end
  end

  #bground color setter
  def set_background_color(r,g,b)
    @@background_color = SDL::Color.new(r,g,b)
  end

  #surface getter
  def surface
    @@screen_surface
  end

  def draw_buffer
    if (ba_r = @@renderer)
      if (s_s = @@screen_surface)
        texture = SDL::Texture.from(s_s, ba_r)
        output_rect = self.calculate_onscreen_rect
        ba_r.copy(
          texture,
          SDL::Rect.new(0, 0, texture.width, texture.height),
          output_rect
        )
      end
    end
  end

  def calculate_onscreen_rect
    if (window = @@window)
      c_size = window.current_size
      @@scale = Math.min(c_size.x.to_f / size.x, c_size.y.to_f / size.y).to_f32
      ratio = size.x.to_f/size.y
      @@offset.x = Math.max(((c_size - c_size.y * ratio) / 2), 0).to_i
      @@offset.y = Math.max(((c_size - c_size.x * ratio) / 2), 0).to_i
      SDL::Rect.new(@@offset.x, @@offset.y, (size.x * @@scale).to_i, (size.y * @@scale).to_i)
    end
  end

  def present
    if (ba_r = @@renderer)
      ba_r.present
    end
  end

  def renderer
    if a == @@renderer
      a
    end
  end

  def window
    @@window
  end

  def camera
    @@camera
  end

  def size
    @@size
  end

  def scale
    @@scale
  end

  def current_scale
    if a == @@renderer
      a.scale[0]
    end
  end

  def fps
    @@fps
  end

  def set_fps(set_fps)
    @@fps = set_fps
  end

  def offset
    @@offset
  end

  extend self
end
