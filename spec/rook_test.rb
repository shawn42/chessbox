
require File.dirname(__FILE__) + '/../test_helper'

class RookTest < Test::Unit::TestCase
	# see that a valid move returns true
	def test_move_valid_good
		board = ChessBoard.create_empty
		test_me = Rook.new board, :black, 'a', 1
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.move_valid?('a', 3)
		assert test_me.move_valid?('g', 1)
	end

	# see that a valid capture returns true
	def test_move_valid_capture
		board = ChessBoard.create_empty
		test_me = Rook.new board, :black, 'a', 1
		pawny = Pawn.new board, :white, 'c', 1
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.move_valid?('c', 1)
	end

	# see that a valid move returns false if a piece is on the landing square
	def test_move_invalid_blocked_by_own_piece
		board = ChessBoard.create_empty
		pawny = Pawn.new board, :black, 'c', 1
		test_me = Rook.new board, :black, 'a', 1
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 1)
	end

	# see that a valid move returns false if a piece is blocking its path
	def test_move_invalid_piece_in_path
		board = ChessBoard.create_empty
		pawny = Pawn.new board, :black, 'c', 1
		pawntastic = Pawn.new board, :white, 'a', 3
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		test_me = Rook.new board, :black, 'a', 1
		board << test_me
		board << pawny
		board << pawntastic 

		assert !test_me.move_valid?('a', 5)
		assert !test_me.move_valid?('e', 1)
	end

	# see that a valid move returns false if the move goes off board
	def test_move_invalid_off_board
		board = ChessBoard.create_empty
		test_me = Rook.new board, :black, 'a', 1
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('z', 1)
		assert !test_me.move_valid?('xx', 1)
		assert !test_me.move_valid?('a', 9)
		assert !test_me.move_valid?('a', -9)
	end

end

