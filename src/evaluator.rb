
require 'chess_board'
class Evaluator

	attr_reader :chess_board
	attr_accessor :weights

	def initialize(board)
		@chess_board = board
		@weights = {:king => 1000, :queen => 757, :rook => 466, :bishop => 441, 
			:knight => 316, :pawn => 100, :double_pawn => 44, :mobility => 11, 
			:center_control => 400, :turn => 40 }
	end

	def score
		material_score + mobility_score + control_score + double_pawn_score + turn_score
	end

	def turn_score
		if @chess_board.turn == :white
			@weights[:turn]
		else
			-1 * @weights[:turn]
		end
	end

	def mobility_score
		white_num_moves = 0
		black_num_moves = 0
		for file in ChessBoard::FILE_NAMES
			for row in ChessBoard::ROW_NAMES
				piece = @chess_board[file,row]	
				unless piece.nil?
					if piece.color == :white
						white_num_moves += piece.moves.size
					else
						black_num_moves += piece.moves.size
					end
				end
			end
		end
		(white_num_moves - black_num_moves) * @weights[:mobility]
	end
	def control_score
		white_control_count = 0
		black_control_count = 0
		for file in ChessBoard::FILE_NAMES
			for row in ChessBoard::ROW_NAMES
				piece = @chess_board[file,row]	
				unless piece.nil?
					if piece.moves.include? 'd4'
						if piece.color == :white
							white_control_count += 1
						else
							black_control_count += 1
						end
					end
					if piece.moves.include? 'e4'
						if piece.color == :white
							white_control_count += 1
						else
							black_control_count += 1
						end
					end
					if piece.moves.include? 'd5'
						if piece.color == :white
							white_control_count += 1
						else
							black_control_count += 1
						end
					end
					if piece.moves.include? 'e5'
						if piece.color == :white
							white_control_count += 1
						else
							black_control_count += 1
						end
					end
				end
			end
		end
		(white_control_count - black_control_count) * @weights[:center_control]
	end
	def double_pawn_score
		white_double_pawn_count = 0
		black_double_pawn_count = 0
		for file in ChessBoard::FILE_NAMES
			for row in ChessBoard::ROW_NAMES
				piece = @chess_board[file,row]	
				unless piece.nil?
					if piece.instance_of? Pawn
						# check for other pawns of same color
						for i in (1..7)
							other_piece = @chess_board[file,(row + i) % 8]
							if other_piece.instance_of?(Pawn) && other_piece.color == piece.color
								if piece.color == :white
									white_double_pawn_count += 1
								else
									black_double_pawn_count += 1
								end
							end
						end
						 
					end
				end
			end
		end
		(black_double_pawn_count - white_double_pawn_count) * @weights[:double_pawn]
	end

	def material_score
		white_material = 0
		black_material = 0
		for row in ChessBoard::ROW_NAMES
			for file in ChessBoard::FILE_NAMES
				piece = @chess_board[file,row]
				unless piece.nil?
					score = @weights[piece.class.to_s.downcase.to_sym]
					if piece.color == :white
						white_material += score
					else
						black_material += score
					end
				end
			end
		end
		white_material - black_material
	end
	
end
