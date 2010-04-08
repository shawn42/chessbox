require File.dirname(__FILE__) + '/../test_helper'


class PawnTest < Test::Unit::TestCase

	def test_move_valid_good_black
		board = ChessBoard.create_empty
		ChessBoard::FILE_NAMES.each do |file|
			ChessBoard::ROW_NAMES.each do |row|
				board << Pawn.new(board, :black, file, row)
			end
		end
		test_me = Pawn.new board, :black, 'd', 6
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king
		board['d', 5] = nil
		board['d', 4] = nil

		assert test_me.move_valid?('d', 5)
		assert test_me.move_valid?('d', 4)
	end

	def test_move_valid_good_white
		board = ChessBoard.create_empty
		test_me = Pawn.new board, :white, 'e', 2
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.move_valid?('e', 3)
		assert test_me.move_valid?('e', 4)
	end

	def test_move_valid_blocked
		board = ChessBoard.create_empty
		test_me = Pawn.new board, :black, 'd', 6
		pawny = Pawn.new board, :black, 'd', 5
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('d', 5)
	end

	def test_move_valid_blocked_by_opponent
		board = ChessBoard.create_empty
		ChessBoard::FILE_NAMES.each do |file|
			ChessBoard::ROW_NAMES.each do |row|
				board << Pawn.new(board, :white, file, row)
			end
		end
		test_me = Pawn.new board, :black, 'd', 6
		pawny = Pawn.new board, :white, 'd', 5
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king
		board['d', 4] = nil

		assert !test_me.move_valid?('d', 5)
		assert !test_me.move_valid?('d', 4)
	end

	def test_move_valid_blocked_by_opponent_black
		board = ChessBoard.create_empty
		ChessBoard::FILE_NAMES.each do |file|
			ChessBoard::ROW_NAMES.each do |row|
				board << Pawn.new(board, :black, file, row)
			end
		end
		test_me = Pawn.new board, :white, 'd', 2
		pawny = Pawn.new board, :black, 'd', 3
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king
		board['d', 4] = nil

		assert !test_me.move_valid?('d', 3)
		assert !test_me.move_valid?('d', 4)
	end

	def test_move_valid_capture
		board = ChessBoard.create_empty
		test_me = Pawn.new board, :black, 'd', 6
		pawny = Pawn.new board, :white, 'c', 5
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.move_valid?('c', 5)
	end

	def test_move_valid_capture_own_color
		board = ChessBoard.create_empty
		test_me = Pawn.new board, :black, 'd', 6
		pawny = Pawn.new board, :black, 'c', 5
		board << test_me
		board << pawny
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 5)
	end

	def test_move_valid_wrong_direction
		board = ChessBoard.create_empty
		test_me = Pawn.new board, :black, 'c', 4
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.move_valid?('c', 5)

		test_me.color = :white
		assert test_me.move_valid?('c', 5)
		assert !test_me.move_valid?('c', 3)
	end

	def test_en_passant
		board = ChessBoard.new
		test_me = Pawn.new board, :white, 'd', 5
		passant_me = Pawn.new board, :black, 'e', 5
		board << test_me
		board << passant_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king
		board.history << {:to_file => 'e', :to_row => 5, :from_file => 'e', 
										:from_row => 7, :piece => passant_me}

		assert test_me.en_passant?('e', 6)
		assert !test_me.en_passant?('d', 6)
	end

	def test_move_valid_en_passant
		board = ChessBoard.new
		test_me = Pawn.new board, :white, 'd', 5
		passant_me = Pawn.new board, :black, 'e', 5
		board << test_me
		board << passant_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king
		board.history << {:to_file => 'e', :to_row => 5, :from_file => 'e', 
										:from_row => 7, :piece => passant_me}

		assert test_me.move_valid?('e', 6)
	end

	def test_move_en_passant_black
		board = ChessBoard.new
		test_me = Pawn.new board, :black, 'd', 4
		passant_me = Pawn.new board, :white, 'e', 4
		board << test_me
		board << passant_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king
		board.history << {:to_file => 'e', :to_row => 4, :from_file => 'e', 
										:from_row => 2, :piece => passant_me}
		test_me.move!('e', 3)

		assert_nil board['e',4]
	end

	def test_move_en_passant_white
		board = ChessBoard.new
		test_me = Pawn.new board, :white, 'd', 5
		passant_me = Pawn.new board, :black, 'e', 5
		board << test_me
		board << passant_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king
		board.history << {:to_file => 'e', :to_row => 5, :from_file => 'e', 
										:from_row => 7, :piece => passant_me}
		test_me.move!('e', 6)

		assert_nil board['e',5]
	end

	def test_promotion
		board = ChessBoard.new
		test_me = Pawn.new board, :white, 'd', 8
		test_me_black = Pawn.new board, :white, 'd', 1
		board << test_me
		board << test_me_black
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert test_me.promotion?
		assert test_me_black.promotion?
	end

	def test_promotion_false
		board = ChessBoard.new
		test_me = Pawn.new board, :white, 'd', 7
		test_me_black = Pawn.new board, :white, 'd', 2
		board << test_me
		board << test_me_black
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert !test_me.promotion?
		assert !test_me_black.promotion?
	end

	def test_promote_white
		board = ChessBoard.new
		test_me = Pawn.new board, :white, 'd', 8
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		test_me.promote
		assert !board['d',8].nil?
		assert_equal Queen, board['d',8].class
		assert_equal 'd', board['d',8].file
		assert_equal 8, board['d',8].row
		assert_equal :white, board['d',8].color
	end

	def test_promote_black
		board = ChessBoard.new
		test_me = Pawn.new board, :black, 'd', 1
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		test_me.promote
		assert !board['d',1].nil?
		assert_equal Queen, board['d',1].class
		assert_equal 'd', board['d',1].file
		assert_equal 1, board['d',1].row
		assert_equal :black, board['d',1].color
	end

	def test_move_valid_when_puts_self_in_check
		board = ChessBoard.new
		test_me = Pawn.new board, :black, 'd', 1
		board << test_me
		black_king = King.new board, :black, 'g', 3
		white_king = King.new board, :white, 'g', 5
		board << black_king
		board << white_king

		assert false, "implement me"
	end

end
