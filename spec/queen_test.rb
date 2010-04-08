
require File.dirname(__FILE__) + '/../test_helper'

class QueenTest < Test::Unit::TestCase

	def test_move_valid_good
		board = ChessBoard.create_empty
		test_me = Queen.new board, :black, 'b', 2
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.move_valid?('b', 4)
		assert test_me.move_valid?('g', 2)
		assert test_me.move_valid?('a', 1)
		assert test_me.move_valid?('f', 6)
	end

	def test_move_valid_capture
		board = ChessBoard.create_empty
		test_me = Queen.new board, :black, 'a', 1
		pawny = Pawn.new board, :white, 'c', 3
		pawny2 = Pawn.new board, :white, 'a', 3
		board << test_me
		board << pawny
		board << pawny2
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.move_valid?('c', 3)
		assert test_me.move_valid?('a', 3)
	end

	def test_move_valid_own_color
		board = ChessBoard.create_empty
		test_me = Queen.new board, :black, 'a', 1
		pawny = Pawn.new board, :black, 'c', 3
		pawny2 = Pawn.new board, :black, 'a', 3
		board << test_me
		board << pawny
		board << pawny2
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 3)
		assert !test_me.move_valid?('a', 3)
	end
	
	def test_move_valid_opposite_color_in_path
		board = ChessBoard.create_empty
		test_me = Queen.new board, :black, 'a', 1
		pawny = Pawn.new board, :white, 'b', 2
		pawny2 = Pawn.new board, :white, 'a', 2
		board << test_me
		board << pawny
		board << pawny2
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 3)
		assert !test_me.move_valid?('a', 3)
	end

	def test_move_valid_own_color_in_path
		board = ChessBoard.create_empty
		test_me = Queen.new board, :black, 'a', 1
		pawny = Pawn.new board, :black, 'b', 2
		pawny2 = Pawn.new board, :black, 'a', 2
		board << test_me
		board << pawny
		board << pawny2
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 3)
		assert !test_me.move_valid?('a', 3)
	end
end
