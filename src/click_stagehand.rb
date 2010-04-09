class ClickStagehand < Stagehand
  def setup
    @input_manager = stage.input_manager

    @currently_over = []
    @click_callbacks = {}

    @clickables = stage.stagehand(:spatial)

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
      puts "WARNING: ClickStagehand: #{clickable.class} does not respond to click_call: #{click_call}!"
    end
    @clickables.add clickable
  end

  def unregister(clickable)
    @clickables.delete clickable
    @click_callbacks.delete clickable
  end

end
