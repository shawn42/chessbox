
require 'chess_piece'
class Knight < ChessPiece
	def move_valid?(to_file, to_row, ignore_check_rules = false)
		return false if to_file.nil?
		return false if to_row.nil?
		x = ChessBoard::FILE_NAMES.index @file
		y = ChessBoard::ROW_NAMES.index @row
		new_x = ChessBoard::FILE_NAMES.index to_file
		new_y = ChessBoard::ROW_NAMES.index to_row
		return false if x.nil?
		return false if y.nil?
		return false if new_x.nil?
		return false if new_y.nil?

		if ((new_x < 0) or (new_y < 0) or ((new_x == x) and (new_y == y)))
			return false
		end
		dx = (x - new_x).abs
		dy = (y - new_y).abs
		if(dx == 1 and dy == 2) or (dx == 2 and dy == 1)
			if board[to_file, to_row].nil? or board[to_file, to_row].color != color
				if ignore_check_rules
					return true
				else
					return !move_puts_self_in_check?(to_file, to_row)
				end
			end
		end

		return false
	end
end
