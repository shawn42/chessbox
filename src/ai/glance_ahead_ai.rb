# Look ahead one move (if I move this piece the new score will be)
require 'evaluator' 
class GlanceAheadAI
	attr_accessor :board

	def do_move!(color = nil)
    color = board.turn if color.nil?
		board.move! find_move(color)
		STDOUT.puts Time.now
		STDOUT.flush
	end

	def find_move(color)
		unless board.nil?
			# TODO do we need to make our own copy of the board( i think this was slower actually)
			# TODO stalemates?
			unless board.checkmate?(:white) or board.checkmate?(:black)
				best_move = nil
				best_move_score = nil

				pieces = []
				if color == :white
					pieces = board.white_pieces
				else
					pieces = board.black_pieces
				end

				moves_to_try = []
				for piece in pieces
					for move in piece.moves
						moves_to_try << "#{piece.file}#{piece.row} #{move}"
					end 
				end

				for try_it in moves_to_try
					# make the move
          puts try_it if $irb_debugging_this_crap 
					moved = board.move! try_it
					# get score
					move_score = rand(100)#Evaluator.new(board).score
					if best_move_score.nil?
						best_move_score = move_score
					end
					
					if color == :white
						if move_score >= best_move_score
							best_move = try_it
							best_move_score = move_score
						end
					else
						if move_score <= best_move_score
							best_move = try_it
							best_move_score = move_score
						end
					end

					# undo move
					if moved
						board.undo_last_move!
					end
				end
				return best_move
			end
			nil
		end
	end
end
