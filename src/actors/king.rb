require 'chess_piece'

class King < ChessPiece
	def move_valid?(to_file, to_row, ignore_check_rules = false)
		# TODO change to throw InvalidKingMoveException and PiecesInTheWayException
		return false if not square_exists? to_file, to_row

		file_index = ChessBoard::FILE_NAMES.index @file
		row_index = ChessBoard::ROW_NAMES.index @row
		to_file_index = ChessBoard::FILE_NAMES.index to_file
		to_row_index = ChessBoard::ROW_NAMES.index to_row

		if ((to_file_index < 0) or (to_row_index < 0) or ((to_file_index == file_index) and (to_row_index == row_index)))
			return false
		end
		dx = (file_index - to_file_index).abs
		dy = (row_index - to_row_index).abs
		return false if (dx > 2 or dy > 1)
		if dx == 2
			if can_castle? to_file
				return !move_puts_self_in_check?(to_file, to_row)
			else
				return false
			end
		end

		if board[to_file, to_row].nil?
			if ignore_check_rules
				return true
			else
				return !move_puts_self_in_check?(to_file, to_row)
			end
		else
			return false if board[to_file, to_row].color == color 
		end
		if ignore_check_rules
			return true
		else
			return !move_puts_self_in_check?(to_file, to_row)
		end
	end

	def move!(to_file, to_row)
		if castling? to_file, to_row
			castle to_file
		end
		super to_file, to_row

	end

	def castle(to_file)
		file_index = ChessBoard::FILE_NAMES.index @file
		to_file_index = ChessBoard::FILE_NAMES.index to_file
		if to_file_index > file_index
			# castling toward h
			rook_file = 'h'
			rook_to_file = 'f'
		else
			# castling toward a
			rook_file = 'a'
			rook_to_file = 'd'
		end
		board[rook_file,@row].move! rook_to_file, @row
	end

	def castling?(to_file, to_row)
		return false if to_row != @row
		file_index = ChessBoard::FILE_NAMES.index @file
		to_file_index = ChessBoard::FILE_NAMES.index to_file
		return false if (to_file_index - file_index).abs != 2
		return true
	end

	def can_castle?(to_file)
    # TODO I THINK THIS IS BROKEN?
		return false if @has_moved
		return false if board.check? color
		file_index = ChessBoard::FILE_NAMES.index @file
		to_file_index = ChessBoard::FILE_NAMES.index to_file
		rook_file = ''
		if to_file_index > file_index
			# castling toward h
			rook_file = 'h'
			files_to_check = ['f','g']
			return false if move_puts_self_in_check? 'f', @row
		else
			# castling toward a
			rook_file = 'a'
			files_to_check = ['b','c','d']
			return false if move_puts_self_in_check? 'd', @row
		end

		return false if board[rook_file, @row].nil? 
		if !board[rook_file, @row].nil? 
			return false if board[rook_file, @row].has_moved
		end
		for file in files_to_check
			# TODO: see if king passes through check
			return false unless board[file, @row].nil?
		end

		return true
	end
end
