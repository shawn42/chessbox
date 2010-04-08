class PlayStage < Stage
  def setup
    super
    @board = spawn :chess_board, :x => 100, :y => 200
    @board.setup_default
  end

  def draw(target)
    target.fill [25,25,25,255]
    super
  end
end

