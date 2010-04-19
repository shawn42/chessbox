class PlayStage < Stage
  def setup
    super
    spawn :stary_night, :speed => 280
    spawn :stary_night, :speed => 110 
    spawn :fps, :x => 200, :y => 30
    @board = spawn :chess_board, :x => 150, :y => 100
    @board.setup_default
  end

  def draw(target)
    target.fill [25,25,25,255]
    super
  end
end

