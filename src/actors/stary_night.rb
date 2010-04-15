# Just scrolls 'stars' toward bottom of screen
class StaryNightView < ActorView
  def draw(target, x_off, y_off)
    @actor.stars.each do |s|
      star_x = s[0]
      star_y = s[1]
      size = s[2]
      target.draw_box_s [star_x,star_y],[star_x+size,star_y+size], Color[:white]
    end
  end
end

class StaryNight < Actor
  has_behaviors :updatable, :layered => {:layer => 0, :parallax => Float::INFINITY}

  attr_accessor :stars
  DEFAULT_PARAMS = {
    :count => 100,
    :size => 1..3,
    :speed => 70
  }
  def setup
    merged_opts = DEFAULT_PARAMS.merge opts
    @stars = []
    @count = merged_opts[:count]
    @sizes = merged_opts[:size].to_a
    @speed = merged_opts[:speed]/1000.0
    @viewport = stage.viewport
    @count.times do
      @stars << generate_star_in(@viewport.width, @viewport.height)
    end
  end

  def generate_star_in(w, h)
    x = rand w
    y = rand h
    size = @sizes[rand(@sizes.size)]
    return [x,y,size]
  end

  def update(time)
    @stars.each do |s|
      s[1] += @speed * time
    end

    @stars.delete_if{|s|s[1] > @viewport.height}
    (@count-@stars.size).times do
      @stars << generate_star_in(@viewport.width, 0)
    end
  end
end
