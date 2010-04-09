require 'behavior'

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
    @hover_manager = @actor.stage.stagehand(:hover)
    @hover_manager.register @actor, enter_callback, exit_callback
  end

  def removed
    @hover_manager.unregister @actor
  end
end

