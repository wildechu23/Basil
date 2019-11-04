DEBUG_ALPHA = "!+#$%&'()*+,-./" \
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
  @@loopfunc = Proc(Nil)?

  @@current_fps = 0

  @@quit = false

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
  
end

def self.game_update
  
end