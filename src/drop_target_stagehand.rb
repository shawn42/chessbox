class DropTargetStagehand < Stagehand

  def setup
    @input_manager = stage.input_manager
    @targetables = stage.stagehand(:spatial)
    @drag_manager = stage.stagehand(:drag)
  end

  def register(targetable, start_drag, dragging_call, stop_drag)
    if targetable.respond_to? start_drag
      @start_drag_callbacks[targetable] = start_drag
    else
      puts "WARNING: DropTargetStagehand: #{targetable.class} does not respond to start_drag: #{start_drag}!"
    end
    if targetable.respond_to? dragging
      @dragging_callbacks[targetable] = dragging
    else
      puts "WARNING: DropTargetStagehand: #{targetable.class} does not respond to dragging: #{dragging}!"
    end
    if targetable.respond_to? stop_drag
      @stop_drag_callbacks[targetable] = stop_drag
    else
      puts "WARNING: DropTargetStagehand: #{targetable.class} does not respond to stop_drag: #{stop_drag}!"
    end

    @targetables.add targetable
  end

  def unregister(targetable)
    @targetables.delete targetable
    @start_drag_callbacks.delete targetable
    @dragging_callbacks.delete targetable
    @stop_drag_callbacks.delete targetable
  end

  private
  def register_start_drag
    @start_drag_callbacks = {}
    @drag_manager.when :drag_start do |x, y, draggable|
    end
  end
end
