class DragStagehand < Stagehand
  extend Publisher

  can_fire :drag_start, :dragging, :drag_stop

  attr_accessor :dragging, :dragged_object

  def setup
    @input_manager = stage.input_manager
    @draggables = stage.stagehand(:spatial)
#    @drop_targets = stage.stagehand(:drop_target)

    register_start_drag
    register_dragging
    register_stop_drag
  end

  def dragging?
    dragging
  end

  def register(draggable, start_drag, dragging_call, stop_drag)
    if draggable.respond_to? start_drag
      @start_drag_callbacks[draggable] = start_drag
    else
      puts "WARNING: DraggableStagehand: #{draggable.class} does not respond to start_drag: #{start_drag}!"
    end
    if draggable.respond_to? dragging_call
      @dragging_callbacks[draggable] = dragging_call
    else
      puts "WARNING: DraggableStagehand: #{draggable.class} does not respond to dragging: #{dragging_call}!"
    end
    if draggable.respond_to? stop_drag
      @stop_drag_callbacks[draggable] = stop_drag
    else
      puts "WARNING: DraggableStagehand: #{draggable.class} does not respond to stop_drag: #{stop_drag}!"
    end

    @draggables.add draggable
  end

  def unregister(draggable)
    @draggables.delete draggable
    @start_drag_callbacks.delete draggable
    @dragging_callbacks.delete draggable
    @stop_drag_callbacks.delete draggable
  end

  private
  def register_start_drag
    @start_drag_callbacks = {}
    @input_manager.reg MouseDownEvent do |evt|
      pos = evt.pos
      x = pos[0]
      y = pos[1]
      targets = @draggables.items_at x, y

      # TODO sort by Z level
      targets.each do |possible_target|
        if @start_drag_callbacks[possible_target] && possible_target.hit_by?(x, y)
          @dragged_object = possible_target
          possible_target.send(@start_drag_callbacks[possible_target], evt.button, x, y) 
          break
        end
      end
      fire :drag_start, x, y, @dragged_object
    end
  end

  def register_dragging
    @dragging_callbacks = {}
    @input_manager.reg MouseMotionEvent do |evt|
      unless @dragged_object.nil?
        pos = evt.pos
        x = pos[0]
        y = pos[1]

        # TODO properly handle the button
        @dragged_object.send(@dragging_callbacks[@dragged_object], 1, x, y) 
        fire :dragging, x, y, @dragged_object
      end
    end
  end

  def register_stop_drag
    @stop_drag_callbacks = {}
    @input_manager.reg MouseUpEvent do |evt|
      unless @dragged_object.nil?
        pos = evt.pos
        x = pos[0]
        y = pos[1]
        # TODO handle button?
        @dragged_object.send(@stop_drag_callbacks[@dragged_object], 1, x, y) 
        fire :drag_stop, x, y, @dragged_object

        @dragged_object = nil
      end
    end
  end
end
