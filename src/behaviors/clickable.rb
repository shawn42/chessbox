require 'behavior'

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
    @click_manager = @actor.stage.stagehand(:click)
    @click_manager.register @actor, click_callback
  end

  def removed
    @click_manager.unregister @actor
  end
end
