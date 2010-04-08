
class Pawn < ChessPiece

  def move!(to_file, to_row)
    if en_passant? to_file, to_row
      attack_en_passant to_file, to_row
    end

    super to_file, to_row

    if promotion?
      promote
    end
  end

  def promotion?
    return true if @row == ChessBoard::ROW_NAMES[0] or @row == ChessBoard::ROW_NAMES[-1]
    return false
  end

  def promote
    queen = Queen.new @board, @color, @file, @row	
    if @color == :white
      board.white_pieces.delete self
    else
      board.black_pieces.delete self
    end
    board[@file,@row] = queen
  end

  def attack_en_passant(to_file, to_row)
    last_move = board.history[-1]
    last_move_dir = (last_move[:from_row] - last_move[:to_row]) < 0 ? 1 : -1
    captured_piece = board[to_file, to_row + last_move_dir]
    if captured_piece.color == :white
      board.white_pieces.delete captured_piece
      board.captured_white << captured_piece
    else
      board.black_pieces.delete captured_piece
      board.captured_black << captured_piece
    end
    board[to_file, to_row + last_move_dir] = nil
  end

  def en_passant?(to_file, to_row)
    file_index = ChessBoard::FILE_NAMES.index @file
    row_index = ChessBoard::ROW_NAMES.index @row
    to_file_index = ChessBoard::FILE_NAMES.index to_file
    to_row_index = ChessBoard::ROW_NAMES.index to_row

    if @color == :white
      return false if row_index > to_row_index
    else
      return false if row_index < to_row_index
    end
    dx = (file_index - to_file_index).abs
    dy = (row_index - to_row_index).abs

    # handle en-passant 
    unless board.history.nil? or board.history.empty?
      last_move = board.history[-1]
      if last_move[:piece].class == Pawn
        if last_move[:piece].color != @color
          if last_move[:to_row] == @row	
            last_move_file_index = ChessBoard::FILE_NAMES.index last_move[:to_file]
            if (last_move_file_index - file_index).abs == 1
              # if last move was two spaces
              if (last_move[:to_row] - last_move[:from_row]).abs == 2
                if board[to_file, to_row].nil? and dx == 1 and dy == 1
                  # EN PASSANT is allowed
                  # TODO add self_in_check? to en passant
                  return true
                end
              end
            end
          end
        end
      end
    end





#    return true if board[to_file, to_row].nil? and dx == 1 and dy == 1
    return false
  end

  def can_en_passant?
    file_index = ChessBoard::FILE_NAMES.index @file
    row_index = ChessBoard::ROW_NAMES.index @row
    # handle en-passant 
    unless board.history.nil? or board.history.empty?
      last_move = board.history[-1]
      if last_move[:piece].class == Pawn
        if last_move[:piece].color != @color
          if last_move[:to_row] == @row	
            last_move_file_index = ChessBoard::FILE_NAMES.index last_move[:to_file]
            if (last_move_file_index - file_index).abs == 1
              # if last move was two spaces
              if (last_move[:to_row] - last_move[:from_row]).abs == 2
                # EN PASSANT is allowed
                # TODO add self_in_check? to en passant
                return true
              end
            end
          end
        end
      end
    end
    return false
  end

  def move_valid?(to_file, to_row, ignore_check_rules = false)
    return false if not square_exists? to_file, to_row

    file_index = ChessBoard::FILE_NAMES.index @file
    row_index = ChessBoard::ROW_NAMES.index @row
    to_file_index = ChessBoard::FILE_NAMES.index to_file
    to_row_index = ChessBoard::ROW_NAMES.index to_row


    if to_file_index == file_index and to_row_index == row_index
      return false
    end
    dx = (file_index - to_file_index).abs
    dy = (row_index - to_row_index).abs

    return false if dy == 2 and has_moved == true
    return false if dy == 2 and dx != 0

    return false if dx > 1
    return false if dy > 2
    return false if dy == 0

    # check direction	
    dir = to_row_index - row_index
    return false if color == :white and dir < 0
    return false if color == :black and dir > 0

    if dx == 1 and dy == 1
      # make sure there's something there to attack
      if board[to_file, to_row].nil? 
        return false unless can_en_passant?
      else
        return false if board[to_file, to_row].color == color
      end
    else
      #check if clear
      if dy == 2
        # check the in between square
        row_name = ChessBoard::ROW_NAMES[to_row_index + (-0.5*dir)]
        return false unless board[to_file, row_name].nil? 
      end
      return false unless board[to_file, to_row].nil? 
    end

    unless ignore_check_rules
      return !move_puts_self_in_check?(to_file, to_row)
    end
    return true

  end
end
