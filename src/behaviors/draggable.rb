require 'behavior'

class Draggable < Behavior
  DEFAULT_CALLBACKS = {
    :start => :start_drag,
    :dragging => :dragging,
    :stop => :stop_drag
  }
  
  def setup
    drag_opts = DEFAULT_CALLBACKS.merge opts
    start_callback = drag_opts[:start]
    dragging_callback = drag_opts[:dragging]
    stop_callback = drag_opts[:stop]

    @drag_manager = @actor.stage.stagehand(:drag)
    @drag_manager.register @actor, start_callback, dragging_callback, stop_callback
  end

  def removed
    @drag_manager.unregister @actor
  end

end
