require 'behavior'
require 'spatial_hash'

#
# Hoverable adds callbacks for when the mouse is hovering over an actor. 
# Will call actor.mouse_(enter|exit)(x,y) by default, 
# but can be told what methods to call
# has_behavior :hoverable
# or
# has_behavior :hoverable => {:enter => :my_hover_method, :exit => :my_exit_method}
#
class Hoverable < Behavior
  DEFAULT_CALLBACKS = {
    :enter => :mouse_enter,
    :exit => :mouse_exit,
  }
  
  def setup
    hover_opts = opts.merge DEFAULT_CALLBACKS
    enter_callback = hover_opts[:enter]
    exit_callback = hover_opts[:exit]
    $hover_man ||= HoverAssistant.new @actor.input_manager  #@actor.director.assistant(:hover)
    @hover_manager = $hover_man
    # TODO Director#assistant(:foo) => lazily instantiate HoverAssistant?
    @hover_manager.register @actor, enter_callback, exit_callback
  end

  def removed
    @hover_manager.unregister @actor
  end
end
class HoverAssistant
  # TODO add listener.respond_to? :when in input_manager
  def when(*args)
  end
  def initialize(input)
    @input_manager = input

    @currently_over = []
    @enter_callbacks = {}
    @exit_callbacks = {}
    @hoverables = SpatialHash.new 50

    @input_manager.reg MouseMotionEvent do |evt|
      leaving_targets = @currently_over
      @currently_over = []
      pos = evt.pos
      x = pos[0]
      y = pos[1]
      targets = @hoverables.items_at x, y
      targets.each do |possible_target|
        if possible_target.hit_by? x, y 
          unless leaving_targets.include? possible_target
            possible_target.send(@enter_callbacks[possible_target], x, y)
          end
          @currently_over << possible_target
        end
      end
      (leaving_targets-@currently_over).each do |leaving|
         leaving.send(@exit_callbacks[leaving], x, y)
      end
    end
  end

  def register(hoverable, enter_call, exit_call)
    if hoverable.respond_to? enter_call
      @enter_callbacks[hoverable] = enter_call
    else
      puts "WARNING: HoverAssistant: #{hoverable.class} does not respond to enter_call: #{enter_call}!"
    end
    if hoverable.respond_to? exit_call
      @exit_callbacks[hoverable] = exit_call
    else
      puts "WARNING: HoverAssistant: #{hoverable.class} does not respond to exit_call: #{exit_call}!"
    end
    @hoverables.add hoverable
  end

end
