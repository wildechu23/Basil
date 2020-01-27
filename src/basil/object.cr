class Basil::Object
  property pos = Vec2(Float64).new 0.0, 0.0
  property size = Vec2(Float64).new 0.0, 0.0
  property hitbox = Basil::Hitbox.new(Vec2.from(0,0), Vec2.from(0,0))

  def init; end
  def update; end
  def draw; end

  # add to to_destroy array
  def destroy
    Basil::Game.to_destroy.push(self)
  end
end