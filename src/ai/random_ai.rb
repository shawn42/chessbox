class RandomAI
	attr_accessor :board

	def do_move!(color)
		board.move! find_move(color)
	end

	def find_move(color)
		unless board.nil?
			# TODO stalemates?
			unless board.checkmate?(:white) or board.checkmate?(:black)
				pieces = []
				if color == :white
					pieces = board.white_pieces
				else
					pieces = board.black_pieces
				end
				move_found = false
				# TODO clean up this loop
				until move_found do
					num_pieces = pieces.size
					piece_num = rand pieces.size
					piece = pieces[piece_num]
					piece_moves = piece.moves
					next if piece_moves.empty?
					#move_found = true
					move_num = rand piece_moves.size

					return "#{piece.file}#{piece.row} #{piece_moves[move_num]}"
				end
			end
		end
	end
end
