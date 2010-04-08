require File.dirname(__FILE__) + '/../test_helper'

class ChessBoardTest < Test::Unit::TestCase
=begin
  # check the creation of an empty board
  def test_creation
  	test_me = ChessBoard.new
  end

	def test_setting_square
  	test_me = ChessBoard.new
		pawny = Pawn.new test_me, :white, 'a', 1
		test_me['a', 1] = pawny
		
		assert_equal pawny, test_me['a', 1]
		assert_nil test_me['a', 3]
	end

	def test_default_board
		test_me = ChessBoard.new
		test_me.setup_default

		# TODO test each item
	end

	def test_bugged
		test_me = ChessBoard.new
		test_me.setup_default
		black_king = test_me['e', 8]

		test_me.move! 'g1 f3'
		test_me.move! 'h7 h6'

		test_me.move! 'e2 e3'
		test_me.move! 'f7 f6'

		test_me.move! 'f1 c4'
		test_me.move! 'a7 a6'

		test_me.move! 'c4 f7'
		test_me.move! 'e8 f7'

		# this breaks it? (somehow, the king gets removed from the board) was a bug
		# in en_passant? on the pawn class
		test_me.move! 'f3 e5'
		# the .class gives me cleaner output
		assert_equal black_king.class, test_me['f', 7].class

	end

  def test_pawn_promote_undo
		test_me = ChessBoard.new
		pawnner = Pawn.new test_me, :white, 'd', 7
		test_me << pawnner
		black_king = King.new test_me, :black, 'g', 3
		white_king = King.new test_me, :white, 'g', 5
		test_me << black_king
		test_me << white_king
    assert_equal 2, test_me.white_pieces.size

    test_me.do_move! 'd', 7, 'd', 8
    assert_equal 2, test_me.white_pieces.size
		assert !test_me['d',8].nil?
		assert_equal Queen, test_me['d',8].class
		assert_equal 'd', test_me['d',8].file
		assert_equal 8, test_me['d',8].row
		assert_equal :white, test_me['d',8].color

    test_me.undo_last_move!
    assert_equal 2, test_me.white_pieces.size
  end
=end
  def test_king_cap_pawn_bug
    test_me = ChessBoard.new
    test_me.setup_default

    test_me.move! "g1-f3"
    test_me.move! "g8-f6"
    test_me.move! "b1-c3"
    test_me.move! "b8-c6"
    test_me.move! "e2-e3"
    test_me.move! "e7-e6"
    test_me.move! "f1-c4"
    test_me.move! "f8-c5"
    test_me.move! "c4-e6"
    test_me.move! "d7-e6"
    test_me.move! "d1-e2"
    test_me.to_ascii

    STDERR.puts "trying d8-d2"
    begin
      $yep = true
      test_me.move! "d8-d2"
    rescue Exception => ex
      STDERR.puts ex
    ensure
      $yep = nil
    end
    test_me.to_ascii
#    STDERR.puts test_me['d',2].moves unless test_me['d',2].nil?
#    test_me.move! "e2-d2"
#    test_me.move! "c5-e3"    
#    test_me.move! "d2-d7"
#    test_me.move! "c8-d7"    
#    test_me.move! "c1-e3"
#    test_me.move! "e8-e7"    
#    test_me.move! "e3-c5"
#    test_me.move! "e7-d8"    
#    test_me.move! "a1-d1"
#    test_me.move! "h7-h6"    
#    test_me.move! "d1-d7"
#    test_me.move! "d8-d7"    
#    test_me.move! "f3-e5"
#    test_me.move! "d7-c8"    
#    test_me.move! "e5-c6"
#    test_me.move! "b7-c6"    
#    test_me.move! "c5-a7"
#    test_me.move! "a8-a7"    
#    test_me.move! "e1-e2"
#    test_me.move! "h8-d8"    
#    test_me.move! "h1-d1"
#    test_me.move! "d8-d1"    
#    test_me.move! "e2-d1"
#    test_me.move! "a7-a4"    
#    test_me.move! "b2-b4"
#    test_me.move! "a4-b4"    
#    test_me.move! "d1-e2"
#    test_me.move! "b4-d4"    
#    test_me.move! "e2-e3"
#    test_me.move! "d4-d1"    
#    test_me.move! "c3-d1"
#    test_me.move! "c8-b7"    
#    test_me.move! "d1-c3"
#    test_me.move! "c6-c5"    
#    test_me.move! "a2-a3"
#    test_me.move! "e6-e5"    
#    test_me.move! "f2-f4"
#    test_me.move! "e5-f4" 


    # this is not valid in the current system
    assert test_me.move!("e3-f3")

  end
end
