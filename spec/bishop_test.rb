
require File.dirname(__FILE__) + '/../test_helper'

class BishopTest < Test::Unit::TestCase

	def test_move_valid_good
		board = ChessBoard.create_empty
		test_me = Bishop.new board, :black, 'd', 4
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.move_valid?('c', 3)
		assert test_me.move_valid?('f', 6)
		assert test_me.move_valid?('a', 1)
		assert test_me.move_valid?('a', 1)
	end

	def test_move_valid_capture
		board = ChessBoard.create_empty
		test_me = Bishop.new board, :black, 'a', 1
		pawny = Pawn.new board, :white, 'c', 3
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.move_valid?('c', 3)
	end

	def test_move_valid_own_color
		board = ChessBoard.create_empty
		test_me = Bishop.new board, :black, 'a', 1
		pawny = Pawn.new board, :black, 'c', 3
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 3)
	end

	def test_move_valid_own_color_in_path
		board = ChessBoard.create_empty
		test_me = Bishop.new board, :black, 'a', 1
		pawny = Pawn.new board, :black, 'b', 2
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 3)
	end

	def test_move_valid_opposite_color_in_path
		board = ChessBoard.create_empty
		test_me = Bishop.new board, :black, 'a', 1
		pawny = Pawn.new board, :white, 'b', 2
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 3)
	end

	def test_move_valid_out_of_bounds
		board = ChessBoard.create_empty
		test_me = Bishop.new board, :black, 'a', 1
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 9)
		assert !test_me.move_valid?('c', -3)
		assert !test_me.move_valid?('z', 3)
		assert !test_me.move_valid?('xx', 3)
	end

	def test_move_valid_not_diag
		board = ChessBoard.create_empty
		test_me = Bishop.new board, :black, 'a', 1
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('a', 4)
		assert !test_me.move_valid?('b', 5)
		assert !test_me.move_valid?('h', 2)
		assert !test_me.move_valid?('g', 8)
	end

	def test_move_valid_up_left
		board = ChessBoard.create_empty
		test_me = Bishop.new board, :white, 'f', 1
    board << test_me
		black_king = King.new board, :black, 'a', 1
		white_king = King.new board, :white, 'a', 8
		board << black_king
		board << white_king

		assert test_me.move_valid?('b', 5)
	end

end
