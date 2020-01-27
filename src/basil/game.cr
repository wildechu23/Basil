# TODO: Basil::KeyManager

DEBUG_ALPHA =
  " !+#$%&'()*+,-./" \
  "0123456789:;<=>?" \
  "@ABCDEFGHIJKLMNO" \
  "PQRSTUVWXYZ[\\]^_" \
  "`abcdefghijklmno" \
  "pqrstuvwxyz{|}~ "

lib LibSDL
  fun ticks = SDL_GetTicks : Int32
  SDL_BLENDMODE_BLEND = "SDL_BLENDMODE_BLEND"
end

class Basil::Game
  # array of all objects
  @@loop = {} of String => Array(Basil::Object)
  # func runs every loop
  @@loopfunc : Proc(Nil)?

  @@show_hitboxes = false

  @@show_debugger = true
  @@sort_debugger = false
  @@debug_string_buffer = [] of String

  @@current_fps = 0
  @@to_destroy = [] of Basil::Object

  @@quit = false

  # main loop
  def self.run
    start_time = 0
    
    loop do
      # wait for frame
      if start_time + 1000/Basil::Renderer.fps <= LibSDL.ticks
        @@current_fps = 1000 / (LibSDL.ticks - start_time)
        start_time = LibSDL.ticks
        self.game_update
        break if @@quit
      end
    end

    # after break ie exiting

    if window = Basil::Renderer.window
      window.destroy
    end
    if renderer = Basil::Renderer.renderer
      renderer.finalize
    end
    puts "Exiting..."
    exit
  end

  def self.game_update
    while (event = SDL::Event.poll)
      case event
      when SDL::Event::Quit
        @@quit = true
      when SDL::Event::Keyboard
        # TODO: Basil::KeyManager.update(event)
      when SDL::Event::MouseButtons
      when SDL::Event::MouseMotion
      when SDL::Event::MouseWheel
      else
        puts "Event not handled: " + event
      end
    end

    # Basil::Renderer.camera.update

    if func = @@loopfunc
      func.call
    end

    # update objs
    Basil::Game.loop.each do |objs|
      objs[1].each do |obj|
        obj.update
      end
    end

    Basil::Renderer.camera.update
    Basil::Renderer.clear_screen(0,0,0)
    # Basil::Map.draw

    # draw objs
    Basil::Game.loop.each do |objs|
      objs[1].each do |obj|
        obj.draw

        if @@show_hitboxes
          if hb = obj.hitbox
            # Basil::Library.set_draw_color(255,0,0,100)
            # Basil::Draw.fill_rect(obj.pos.x + hb.pos.x, obj.pos.y + hb.pos.y, hb.size.x.to_i, hb.size.y.to_i)
          end
        end
      end
    end
    Basil::Renderer.draw_buffer

    if @@show_debugger
      Basil::Game.draw_debug
    end

    Basil::Renderer.present
    # Basil::KeyManager.clear_pressed
    Basil::Game.destroy_all_in_buffer
    # Basil::Library::Mouse.update
  end

  def self.getfps
    @@current_fps
  end

  def self.set_loopfunc(func)
    @@loopfunc = func
  end

  def self.show_hitboxes(bool)
    @@show_hitboxes = bool
  end
  
  def self.quit
    @@quit = true
  end

  def self.loop
    @@loop = true
  end

  def self.debug(string)
    @@debug_string_buffer << string
  end

  # TODO
  def self.draw_debug
  end

  def self.to_destroy
    @@to_destroy
  end

  def self.destroy_all_in_buffer
    @@to_destroy.each do |obj|
      Basil::Game.loop[obj.class.to_s].delete(obj)
      if Basil::Game.loop[obj.class.to_s].size == 0
        # TODO: Delete key
      end
    end
    @@to_destroy = [] of Basil::Object
  end
end