
require File.dirname(__FILE__) + '/../test_helper'

class KnightTest < Test::Unit::TestCase

	# see that a valid move returns true
	def test_move_valid_good
		board = ChessBoard.create_empty
		test_me = Knight.new board, :black, 'b', 1
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.move_valid?('c', 3)
		assert test_me.move_valid?('a', 3)
	end

	# see that a valid capture returns true
	def test_move_valid_capture
		board = ChessBoard.create_empty
		test_me = Knight.new board, :black, 'b', 1
		pawny = Pawn.new board, :white, 'c', 3
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.move_valid?('c', 3)
	end

	# see that a valid move returns false if a piece is on the landing square
	def test_move_invalid_blocked_by_own_piece
		board = ChessBoard.create_empty
		pawny = Pawn.new board, :black, 'c', 3
		test_me = Knight.new board, :black, 'b', 1
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 3)
	end

	# see that a valid move returns false if the move goes off board
	def test_move_invalid_off_board
		board = ChessBoard.create_empty
		test_me = Knight.new board, :black, 'b', 1
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', -2)
		assert !test_me.move_valid?('z', 5)
	end
end
