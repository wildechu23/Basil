class Basil::Hitbox
  property pos : Vec2(Int32)
  property size : Vec2(Int32)

  def initialize(@pos : Vec2, @size : Vec2); end

  def set(x,y,w,h)
    @pos = Vec2.from(x,y)
    @size = Vec2.from(w,h)
  end
  
  def get
    {@pos.x, @pos.y, @size.x, @size.y}
  end

  def meeting?(x, y, foreign)
    # basic box collision
    # check each corner with every corner of every instance
    if (typeof(foreign) == Class || String)
      objs = Basil::Game.loop[foreign.to_s]
    else
      objs = foreign
    end

    if (objects_to_check = objs.as(Array(Basil::Object)))
      objects_to_check.each do |other|
        if (box_collision_check(self.hitbox, other.hitbox, x, y))
          return true
        end
      end
    end
    return false
  end

  def point_in?(x, y)
    # encloses a rectangle
    x >= @pos.x && x <= @pos.x + @size.x && y >= @pos.y && y <= @pos.y + size.y
  end

  def box_collision_check(this, other, x, y)
    # >=, <
    if this.x + x >= other.x && this.x + x < other.x + other.w && this.y + y >= other.y && this.y + y < other.y + other.h ||
       (this.x + x + this.w) >= other.x && (this.x + x + this.w) < other.x + other.w && this.y + y >= other.y && this.y + y < other.y + other.h ||
       (this.x + x + this.w) >= other.x && (this.x + x + this.w) < other.x + other.w && (this.y + y + this.h) >= other.y && (this.y + y + this.h) < other.y + other.h ||
       this.x + x >= other.x && this.x + x < other.x + other.w && (this.y + y + this.h) >= other.y && (this.y + y + this.h) < other.y + other.h
      return true
    else
      return false
    end
  end

  def meeting_tile?(xoffset, yoffset, tile, accuracy = 2)

  end

  def meeting_tile_layer?(xoffset, yoffset, tile, accuracy = 2)

  end

  def mouse_in?
    # point_in? Library::Mouse.pos.x, Library::Mouse.pos.y
  end

  # def pressed?
  #   if b = Library::Mouse.primary
  #     mouse_in? && b.pressed?
  #   else
  #     false
  #   end
  # end
  
  # def held?
  #   if b = Library::Mouse.primary
  #     mouse_in? && b.held?
  #   else
  #     false
  #   end
  # end
end