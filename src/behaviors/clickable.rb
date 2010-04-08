require 'behavior'
require 'spatial_hash'

#
# Clickable adds callbacks for when the mouse is clicking over an actor. 
# Will call actor.mouse_(enter|exit)(x,y) by default, 
# but can be told what methods to call
# has_behavior :clickable
# or
# has_behavior :clickable => {:enter => :my_click_method, :exit => :my_exit_method}
#
class Clickable < Behavior
  DEFAULT_CALLBACKS = {
    :click => :mouse_clicked,
  }
  
  def setup
    click_opts = opts.merge DEFAULT_CALLBACKS
    click_callback = click_opts[:click]
    $click_man ||= ClickAssistant.new @actor.input_manager  #@actor.director.assistant(:click)
    @click_manager = $click_man
    # TODO Director#assistant(:foo) => lazily instantiate ClickAssistant?
    @click_manager.register @actor, click_callback
  end

  def removed
    @click_manager.unregister @actor
  end
end
class ClickAssistant
  # TODO add listener.respond_to? :when in input_manager
  def when(*args)
  end
  def initialize(input)
    @input_manager = input

    @currently_over = []
    @click_callbacks = {}

    # TODO track this in one place?
    # SpatialAssistant maybe?
    @clickables = SpatialHash.new 50

    @input_manager.reg MouseUpEvent do |evt|
      pos = evt.pos
      x = pos[0]
      y = pos[1]
      targets = @clickables.items_at x, y
      targets.each do |possible_target|
        possible_target.send(@click_callbacks[possible_target], evt.button, x, y) if possible_target.hit_by? x, y 
      end
    end
  end

  def register(clickable, click_call)
    if clickable.respond_to? click_call
      @click_callbacks[clickable] = click_call
    else
      puts "WARNING: ClickAssistant: #{clickable.class} does not respond to click_call: #{click_call}!"
    end
    @clickables.add clickable
  end

  def unregister(clickable)
    @clickables.delete clickable
    @click_callbacks.delete clickable
  end

end
