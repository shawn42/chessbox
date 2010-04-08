
class Queen < ChessPiece
	def move_valid?(to_file, to_row, ignore_check_rules = false)
		if valid_diagonal_move? to_file, to_row or valid_row_column_move? to_file, to_row 
			if ignore_check_rules
				return true
			else
				return !move_puts_self_in_check?(to_file, to_row)
			end
		end
		return false
	end
end
