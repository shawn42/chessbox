require File.dirname(__FILE__) + '/../test_helper'

class KingTest < Test::Unit::TestCase

  def xtest_move_valid_bug
		board = ChessBoard.create_empty
		pawny = Pawn.new board, :white, 'd', 5
		pawny.has_moved = true
		board << pawny
		black_king = King.new board, :black, 'd', 6
		white_king = King.new board, :white, 'e', 4
		black_king.has_moved = true
		white_king.has_moved = true
		board << black_king
		board << white_king

		Evaluator.new(board).score
  end

  def xtest_move_valid_bug_king_not_moved
		board = ChessBoard.create_empty
		pawny = Pawn.new board, :white, 'd', 2
		pawny.has_moved = true
		board << pawny
		black_king = King.new board, :black, 'd', 3
		white_king = King.new board, :white, 'e', 1
		black_king.has_moved = false
		white_king.has_moved = true
		board << black_king
		board << white_king

    # BUG test, this was deleting the black king off the board due to a
    # bug in the king class
		assert !black_king.move_valid?('b', 2)
		assert !board.king(:black).nil?
		assert !black_king.move_valid?('b', 3)
  end

  def test_check_bug
		board = ChessBoard.create_empty
		queen = Queen.new board, :black, 'd', 8
		board << queen
		black_king = King.new board, :black, 'a', 3
		white_king = King.new board, :white, 'e', 1
		black_king.has_moved = true
		white_king.has_moved = true
		board << black_king
		board << white_king
    board.turn = :black
    board.update_available_moves(false)


    board.to_ascii
    board.move! 'd8-d2'
    board.to_ascii
  end
end
