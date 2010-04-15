require 'chess_board'

class ChessPieceView < GraphicalActorView
  def setup
    @half_width = @actor.width/2
    @radius = 20
    @color = [255,255,255,150]
  end

  def draw(target, x_off, y_off)
    super
    target.draw_circle_s [@actor.x+@half_width,@actor.y+@half_width], @radius, @color if @actor.highlighted?
  end
end

class ChessPiece < Actor
  has_behavior :hoverable, :clickable, :draggable

	attr_accessor :file, :row, :color, :has_moved, :board, :moves, :image, :width, :height

	def setup
		@board = opts[:board]
		@color = opts[:color]
		@file = opts[:file]
		@row = opts[:row]
		@has_moved = false
		@moves = []
    @image = resource_manager.load_image "#{@color}_#{self.class.to_s.downcase}.png"

    @width, @height = *@image.size
    @x = ChessBoard::FILE_NAMES.index(@file) * 40 + 4 + @board.x
    @y = (ChessBoard::ROW_NAMES.size-ChessBoard::ROW_NAMES.index(@row)-1) * 40 + 4 + @board.y

	end

  # TODO need to convert these coords w/ the viewport ..
  def dragging(button, x, y)
#    puts "DRAGGING!"
    @x = x
    @y = y
  end
  # TODO need to convert these coords w/ the viewport ..
  def start_drag(button, x, y)
#    puts "START DRAGGING!"
  end
  def stop_drag(button, x, y)
#    puts "STOP DRAGGING!"
  end

  def highlighted?
    @highlighted
  end

  def hit_by?(mouse_x,mouse_y)
    if mouse_x >= x && mouse_y >= y && 
      mouse_x <= (x+width) &&
      mouse_y <= (y+height)
      true
    else
      false
    end
  end

  def mouse_clicked(button, mouse_x,mouse_y)
    puts "clicked #{self.class} #{self.file}#{self.row}"
  end

  def mouse_enter(mouse_x,mouse_y)
    @highlighted = true
  end

  def mouse_exit(mouse_x,mouse_y)
    @highlighted = false
  end


	def move!(to_file, to_row)
		board[file, row] = nil
		board[to_file, to_row] = self
		@file = to_file
		@row = to_row
		@has_moved = true
	end

	def add_move(move_str)
		@moves << "#{move_str}"
	end

	def clear_moves
		@moves = []
	end

	def move_puts_self_in_check?(to_file, to_row)
    moved = false
    # assume invalid
    self_check = true
    begin
     # TODO NOTE: we know the move is valid, only checking for check
     # validity
#     STDERR.puts caller.join("\n")
     STDERR.puts "self check #{self.color} #{self.class} #{file}#{row}-#{to_file}#{to_row}"
     moved = board.do_move! file, row, to_file, to_row, true, true
     self_check = board.check? color
    rescue
    end
    board.undo_last_move!(true) if moved

    return self_check

    # TODO remove this
		board[@file, @row] = nil
		to_be_captured = board[to_file, to_row]
		board[to_file, to_row] = self
		orig_file = @file
		orig_row = @row
		@file = to_file
		@row = to_row
		check = board.check? color
		@file = orig_file
		@row = orig_row
		board[to_file, to_row] = to_be_captured
		board[@file, @row] = self

		return check
	end
	
	def valid_diagonal_move?(to_file, to_row )
		return false if not square_exists? to_file, to_row

		file_index = ChessBoard::FILE_NAMES.index @file
		row_index = ChessBoard::ROW_NAMES.index @row
		to_file_index = ChessBoard::FILE_NAMES.index to_file
		to_row_index = ChessBoard::ROW_NAMES.index to_row

		dfile = ( file_index - to_file_index ).abs
		drow = ( row_index - to_row_index ).abs

		# For a diagonal move, BOTH dfile and dfile must be > 0 and equal
		return false if (dfile == 0 or drow == 0) or (dfile != drow)
		unless board[to_file, to_row].nil?
			return false if	board[to_file, to_row].color == color
		end

		# Now for ickrow conditionals given the direction we travel
		if file_index < to_file_index # if moving right
			if row_index < to_row_index # if moving up
				dfile.times do |i|
					next if i == 0
					file_name = ChessBoard::FILE_NAMES[file_index+i]
					row_name = ChessBoard::ROW_NAMES[row_index+i]
					return false unless board[file_name, row_name].nil? 
				end
			else # if moving down
				dfile.times do |i| 
					next if i == 0
					file_name = ChessBoard::FILE_NAMES[file_index+i]
					row_name = ChessBoard::ROW_NAMES[row_index-i]
					return false unless board[file_name, row_name].nil? 
				end
			end
		else
			if row_index < to_row_index
				dfile.times do |i|
					next if i == 0
					file_name = ChessBoard::FILE_NAMES[file_index-i]
					row_name = ChessBoard::ROW_NAMES[row_index+i]
					return false unless board[file_name, row_name].nil? 
				end
			else
				dfile.times do |i|
					next if i == 0
					file_name = ChessBoard::FILE_NAMES[file_index-i]
					row_name = ChessBoard::ROW_NAMES[row_index-i]
					return false unless board[file_name, row_name].nil? 
				end
			end
		end
		# If we got this far, all is well
		return true
	end

	def square_exists?(file, row)
		return false unless ChessBoard::FILE_NAMES.include? file
		return false unless ChessBoard::ROW_NAMES.include? row
		return true
	end

	def valid_row_column_move?(to_file, to_row)
		return false if not square_exists? to_file, to_row

		file_index = ChessBoard::FILE_NAMES.index @file
		row_index = ChessBoard::ROW_NAMES.index @row
		to_file_index = ChessBoard::FILE_NAMES.index to_file
		to_row_index = ChessBoard::ROW_NAMES.index to_row

		dfile = ( file_index - to_file_index ).abs
		drow = ( row_index - to_row_index ).abs

		# Check to make sure it is a row OR a column move
		return false if dfile > 0 and drow > 0
		unless board[to_file, to_row].nil?
			return false if	board[to_file, to_row].color == color
		end

		# Check row moves
		if dfile > 0
			row_name = ChessBoard::ROW_NAMES[to_row_index]
			if file_index < to_file_index
				if dfile != 1
					(file_index+1).upto( to_file_index-1 ) do |i|
						file_name = ChessBoard::FILE_NAMES[i]
						return false unless board[file_name, row_name].nil? 
					end
				end
			else
				if dfile != 1
					(to_file_index+1).upto( file_index-1 ) do |i| 
						file_name = ChessBoard::FILE_NAMES[i]
						return false unless board[file_name, row_name].nil? 
					end
				end
			end
			# Check column moves
		else
			file_name = ChessBoard::FILE_NAMES[to_file_index]
			if row_index < to_row_index
				if drow != 1
					(row_index+1).upto( to_row_index-1 ) do |i|
						row_name = ChessBoard::ROW_NAMES[i]
						return false unless board[file_name, row_name].nil? 
					end
				end
			else
				if drow != 1
					(to_row_index+1).upto( row_index-1 ) do |i| 
						row_name = ChessBoard::ROW_NAMES[i]
						return false unless board[file_name, row_name].nil? 
					end
				end
			end
		end
		# If we got this far, all is well
		return true
	end
end
