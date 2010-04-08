require 'chess_piece'
require 'rook'
require 'knight'
require 'bishop'
require 'queen'
require 'king'
require 'pawn'

class ChessBoardView < ActorView
  def draw(target, x_off, y_off)
    board = @actor
    board_x = board.x
    board_y = board.y
    square_size = 40

    ChessBoard::ROW_NAMES.reverse.each_with_index do |row, i|
			ChessBoard::FILE_NAMES.each_with_index do |file, j|
        piece_x = board_x + j * square_size
        piece_y = board_y + i * square_size
        color = Color[:white]
        color = Color[:black] if (i.even? && j.odd?) || (i.odd? && j.even?)
        target.draw_box_s [piece_x,piece_y], [piece_x+square_size,piece_y+square_size], color
			end
		end
  end
end

class ChessBoard < Actor
	attr_accessor :turn, :board, :history, :message, :black_pieces, :white_pieces, :captured_black, :captured_white
	FILE_NAMES = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
	ROW_NAMES = [1, 2, 3, 4, 5, 6, 7, 8]

	def self.create_empty
		ChessBoard.new
	end

	def clear
		for file in FILE_NAMES
			@board[file] = []
			for row in ROW_NAMES
				@board[file][row] = nil
			end
		end
	end

	def setup
		@board = {}
		@message = {}
		@message[:black] = ''
		@message[:white] = ''
		@message[:all] = ''
		@turn = :white
		@history = []	
		@black_pieces = []	
		@white_pieces = []	
		@captured_black = []	
		@captured_white = []	
		clear
	end

  def deep_clone
    Marshal::load(Marshal.dump(self))
  end

	def [](file, row)
		if FILE_NAMES.include? file
			if ROW_NAMES.include? row
				@board[file][row]
			end
		end
	end
	def []=(file, row, val)
		if FILE_NAMES.include? file
			if ROW_NAMES.include? row
				if @board[file][row].class == King
          unless val.nil?
            if val.class == Queen
              STDERR.puts "KING GO AWAY[#{file}#{row}]"
              STDERR.puts @board[file][row].color
              STDERR.puts val.class
              STDERR.puts caller.join("\n")
            end
          end
        end
        unless val.nil?
          if val.class == King
            STDERR.puts "KING COME BACK"
            STDERR.puts val.color
            STDERR.puts val.class
          end
        end
				@board[file][row] = val
				unless val.nil?
					if val.color == :white
						unless @white_pieces.include? val
							@white_pieces << val
						end
					else
						unless @black_pieces.include? val
							@black_pieces << val
						end
					end
				end
			end
		end
	end

	def setup_default

		for col in FILE_NAMES
			self[col,2] = spawn :pawn, :board => self, :color => :white, :file => col, :row => 2, :view => ChessPieceView
			self[col,7] = spawn :pawn, :board => self, :color => :black, :file => col, :row => 7, :view => ChessPieceView
		end

		self['a',1] = spawn :rook, :board => self, :color => :white, :file => 'a', :row => 1, :view => ChessPieceView
		self['h',1] = spawn :rook, :board => self, :color => :white, :file => 'h', :row => 1, :view => ChessPieceView
		self['a',8] = spawn :rook, :board => self, :color => :black, :file => 'a', :row => 8, :view => ChessPieceView
		self['h',8] = spawn :rook, :board => self, :color => :black, :file => 'h', :row => 8, :view => ChessPieceView

		self['b',1] = spawn :knight, :board => self, :color => :white, :file => 'b', :row => 1, :view => ChessPieceView
		self['g',1] = spawn :knight, :board => self, :color => :white, :file => 'g', :row => 1, :view => ChessPieceView
		self['b',8] = spawn :knight, :board => self, :color => :black, :file => 'b', :row => 8, :view => ChessPieceView
		self['g',8] = spawn :knight, :board => self, :color => :black, :file => 'g', :row => 8, :view => ChessPieceView

		self['c',1] = spawn :bishop, :board => self, :color => :white, :file => 'c', :row => 1, :view => ChessPieceView
		self['f',1] = spawn :bishop, :board => self, :color => :white, :file => 'f', :row => 1, :view => ChessPieceView
		self['c',8] = spawn :bishop, :board => self, :color => :black, :file => 'c', :row => 8, :view => ChessPieceView
		self['f',8] = spawn :bishop, :board => self, :color => :black, :file => 'f', :row => 8, :view => ChessPieceView

		self['d',1] = spawn :queen, :board => self, :color => :white, :file => 'd', :row => 1, :view => ChessPieceView
		self['d',8] = spawn :queen, :board => self, :color => :black, :file => 'd', :row => 8, :view => ChessPieceView

		self['e',1] = spawn :king, :board => self, :color => :white, :file => 'e', :row => 1, :view => ChessPieceView
		self['e',8] = spawn :king, :board => self, :color => :black, :file => 'e', :row => 8, :view => ChessPieceView
		update_available_moves true

	end

	#TODO throw if piece is already there
	def <<(piece)
		self[piece.file, piece.row] = piece
	end

	def history_to_ascii
		STDOUT.puts "    Game History"
		STDOUT.puts "   _ _ _ _ _ _ _ _ "
		new_round = true
		round_count = 1
		for move in @history
			if new_round
				STDOUT.write "\n#{round_count})   " 
				round_count += 1
			end

			STDOUT.write move[:from_file] + move[:from_row].to_s + '-' + move[:to_file] + move[:to_row].to_s + '    '
			new_round = !new_round
		end
		STDOUT.puts "\n   _ _ _ _ _ _ _ _ "

	end

	def piece_to_ascii(piece)
		if piece.nil?
			return ' '
		else
			letter = ''
			if piece.class == Knight
				letter = piece.class.to_s[1].chr.upcase
			else
				letter = piece.class.to_s[0].chr.upcase
			end
			if piece.color == :black
				letter.downcase!
			end
			return letter
		end
	end
	def to_ascii(output = STDOUT)
		output.puts "#{@turn.to_s.capitalize} to move."
		for white_piece in @captured_white
			output.write " " + piece_to_ascii(white_piece)
		end
		output.puts ""
		output.puts "       BLACK"
		output.puts "   _ _ _ _ _ _ _ _ "
		for row in ROW_NAMES.reverse
			output.write "#{row} |"
			for file in FILE_NAMES
				square = self[file,row]
				output.write piece_to_ascii(square)
				output.write "|"
			end
			output.write "\n"
		end
		output.puts "   - - - - - - - - "
		output.puts "   #{FILE_NAMES.join '|'}"
		output.puts "       WHITE"
		for black_piece in @captured_black
			output.write " " + piece_to_ascii(black_piece)
		end
		output.puts ""
	end

	def move!(move_string)
		notationRegExp = Regexp.new /(\w)(\d)[-|\s](\w)(\d)/i
		match = notationRegExp.match(move_string)
		if match.nil?
			# TODO: what to do here?
			@message[:all] = "INCORRECT FORMAT:[#{move_string}]"
			return false
		end
		do_move! match[1], match[2].to_i, match[3], match[4].to_i
	end

	#TODO different name for this method
	def do_move!(file, row, to_file, to_row, ignore_check_rules = false, ignore_validity = false)
		current_piece = self[file, row]
		return false if current_piece.nil?
		@message[current_piece.color] = ""
		unless current_piece.color == @turn
			@message[current_piece.color] = "It's not your turn."
			return false
		end
		if ignore_validity or current_piece.move_valid? to_file, to_row, ignore_check_rules
			@message[:all] = ''

			add_move_to_history file, row, to_file, to_row
			captured_piece = self[to_file, to_row]
			current_piece.move! to_file, to_row

			unless captured_piece.nil?
				if captured_piece.color == :white
					white_pieces.delete captured_piece
					captured_white << captured_piece
				else
					black_pieces.delete captured_piece
					captured_black << captured_piece
				end
			end

			update_available_moves(ignore_check_rules) unless ignore_check_rules or ignore_validity
      STDERR.puts "moves updated..."
			notation = ''
			if @turn == :white
				if check? :black
					if checkmate? :black
						notation = '#'
					else
						notation = '+'
					end
				end
			else
				if check? :white
					if checkmate? :white
						notation = '#'
					else
						notation = '+'
					end
				end
			end

			@history[-1][:notation] = notation

			switch_turns
			if @history[-1][:notation] == '+'
				@message[:all] = "check!" 
			end
			if @history[-1][:notation] == '#'
				@message[:all] = "checkmate!" 
			end
			return true
		else
			@message[current_piece.color] =  "#{file}#{row}-#{to_file}#{to_row} is not a valid move"
			return false
		end
	end

	# Must be called before the move is made
	def add_move_to_history(file, row, to_file, to_row)
		piece = self[file, row]
    if piece.nil?
      to_ascii
      puts "add_move_to_history nil piece"
      for line in caller
        puts line
      end
      gets
    end
		if piece.instance_of? King
			if piece.castling? to_file, to_row
				castling = true
			else
				castling = false
			end
		end
		first_move = !piece.has_moved
		move_hash = {
			:from_file => file, :from_row => row, 
			:to_file => to_file, :to_row => to_row, 
			:piece => piece, :captured_piece => self[to_file, to_row],
			:first_move => first_move, :castling => castling
		}
		@history << move_hash
	end

	def switch_turns
		if @turn == :white
			@turn = :black
		else
			@turn = :white
		end
	end


	def king(color)
		for row in ROW_NAMES
			for file in FILE_NAMES
				piece = self[file,row]
				return piece if (!piece.nil?) and piece.color == color and piece.instance_of? King
			end
		end
		nil
	end

	def checkmate?(color)
		# TODO is this check? call redundant?
		unless check? color
			return false
		end
		checked_king = king color
		orig_file = checked_king.file
		orig_row = checked_king.row
		# for each piece, if any move gets us out of check
		for file in FILE_NAMES
			for row in ROW_NAMES
				piece = self[file,row]	
				unless piece.nil? or piece.color != color


=begin
					# for each of piece's moves
					for move_to_try in piece.moves
						move_string = "#{piece.file}#{piece.row} #{move_to_try}"
						# make it (using board)
						moved = move! move_string 
						# see if we are in check 
						if moved 
							checked = check? color
							undo_last_move!
							return false unless checked
						end
					end 

=end
					for to_file in FILE_NAMES
						for to_row in ROW_NAMES
							# see if this gets us out of check
							if piece.move_valid? to_file, to_row
								# try it
								orig_file = piece.file
								orig_row = piece.row
								orig_piece = self[to_file, to_row]
								piece.move! to_file, to_row
								in_check = check? color
								piece.move! orig_file, orig_row
								self[to_file, to_row] = orig_piece
								return false unless in_check
							end
						end
					end
				end
			end
		end
		return true
	end

	def check?(color)
		enemy_king = king color
		#return false if enemy_king.nil?
		raise "Could not find #{color.to_s} King!" if enemy_king.nil?

		for row in ROW_NAMES
			for file in FILE_NAMES
				piece = self[file,row]
				unless piece.nil?
					if piece.color != color
						unless piece.moves.nil?
							if piece.moves.include? "#{enemy_king.file}#{enemy_king.row}"
                STDERR.puts "check(#{color}) returning true" if $yep
                return true
              end
#							return true if piece.moves.include? "#{enemy_king.file}#{enemy_king.row}"
						end
					end
				end
			end
		end
    STDERR.puts "check(#{color}) returning false" if $yep
		return false
	end

	def undo_last_move!(ignore_check_rules = false)
		last_move = history.pop
		captured_piece = last_move[:captured_piece]

    # IS SOMETHING WITH EN PASSANT BROKEN???
    # it happens if you do a d2 d4 then the second move of glance ahead will
    # trigger it
    # TODO XXX? this is duplicated
#    unless self[last_move[:to_file],last_move[:to_row]] === last_move[:piece]
#      promoted_piece = self[last_move[:to_file],last_move[:to_row]]
#      if promoted_piece.color == :white
#        white_pieces.delete promoted_piece
#      else
#        white_pieces.delete promoted_piece
#      end
#    end
		if last_move[:piece].instance_of? Pawn
			if @row == ChessBoard::ROW_NAMES[0] or @row == ChessBoard::ROW_NAMES[-1]
				# we just promoted
				promoted_piece = self[last_move[:to_file],last_move[:to_row]]
				if promoted_piece.instance_of? Queen # TODO what if they promoted to other than a queen
					if promoted_piece.color == :white
						white_pieces.delete promoted_piece
					else
						black_pieces.delete promoted_piece
					end
				end	
			end
		end

		self[last_move[:from_file],last_move[:from_row]] = last_move[:piece]
		last_move[:piece].file = last_move[:from_file]
		last_move[:piece].row = last_move[:from_row]
		last_move[:piece].has_moved = !last_move[:first_move]
    self[last_move[:to_file],last_move[:to_row]] = captured_piece
		unless captured_piece.nil?
			if captured_piece.color == :white
				captured_white.delete captured_piece
			else
				captured_black.delete captured_piece
			end
		end
		if last_move[:castling]
			# figure out which rook
			if last_move[:to_file] == 'g'
				# put it back
				rook_file = 'f'
				rook_to_file = 'h'
			else
				rook_file = 'd'
				rook_to_file = 'a'
			end
			rook = self[rook_file, last_move[:to_row]]
			self[rook_to_file, last_move[:to_row]] = rook
			self[rook_file, last_move[:to_row]].has_moved = false
			self[rook_file, last_move[:to_row]] = nil
			rook.file = rook_to_file
		end

		switch_turns
		update_available_moves(ignore_check_rules) unless ignore_check_rules 
	end

	def update_available_moves(ignore_check_rules = false)
		# TODO finish this
    STDERR.puts "update_available_moves(#{ignore_check_rules})" if $yep
		for file in ChessBoard::FILE_NAMES
			for row in ChessBoard::ROW_NAMES
				piece = self[file,row]	
				unless piece.nil?
					piece.clear_moves

          # TODO lookup based on piece type  ie bishops only look on
          # diagonals instead of all squares
          for to_file in ChessBoard::FILE_NAMES
						for to_row in ChessBoard::ROW_NAMES
							if piece.move_valid? to_file, to_row, ignore_check_rules
								piece.add_move "#{to_file}#{to_row}"
							end
						end
					end
				end
			end
		end
    true
	end
end
