# This area consists of the Board Class
class Board
  attr_accessor :grid

  def full?
    @grid.all? { |row| row.none? { |cell| cell == "-" } }
  end

  def initialize
    @grid = Array.new(3) { Array.new(3, "-") }
  end

  def display
    count = 1
    @grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if cell == "-"
          print count
        else
          print cell
        end
        count += 1
        print j < 2 ? " | " : "\n"
      end
      puts "---------" if i < 2
    end
  end

  def place_faction(row, col, faction)
    puts "Received Row: #{row}, Col: #{col}" # Diagnostic print
    puts "Current grid state: #{@grid.inspect}"
    if @grid[row][col] == "-"
      @grid[row][col] = faction
      true
    else
      puts "Spot already taken! Choose another."
      false
    end
  end

  def victory?
    (0..2).any? { |i| @grid[i].uniq.length == 1 && @grid[i][0] != "-"} ||
      (0..2).any? { |i| @grid.map { |row| row[i] }.uniq.length == 1 && @grid[0][i] != "-"} ||
      [@grid[0][0], @grid[1][1], @grid[2][2]].uniq.length == 1 && @grid[1][1] != "-" ||
      [@grid[0][2], @grid[1][1], @grid[2][0]].uniq.length == 1 && @grid[1][1] != "-"
  end
end

# Board class represents the game and its state.
# Key Features Include >
# Full - Checks if the game is full, which will be used to determine if the game ends in a tie or not.
# Initialize - Initializes our 3x3 grid which is fulled with "-".
# Display - shows the current state of the board to the player.
# Place Faction - Attempts to place a players faction on the board. If the spot is already taken, it will be alert that player.
# Victory - Checks if there is a winning state on the board
# ----- This class is important to use because it will handle our game logic and make sure stuff is updated.

# Here we design the Player Class
class Player
  attr_accessor :name, :faction

  def initialize(name, faction)
    @name = name
    @faction = faction
  end
end

# The player class represents the people who are playing the game.
# This class has two instance variables which are @name and @faction.
# The "@name" holds the designation of the player (eg. Player1 or Player2)
# The @faction class holds the players chosen faction (eg. Demacia or Noxus)

# Here we design the Game Class
class Game
  def initialize
    @board = Board.new
    puts "Welcome to Summoner's Rift Tic Tac Toe!"

    puts "Player 1, choose your faction (Demacia/Noxus):"
    faction1 = gets.chomp
    @player1 = Player.new("Player 1", faction1)

    faction2 = faction1 == "Demacia" ? "Noxus" : "Demacia"
    @player2 = Player.new("Player 2", faction2)

    @current_player = @player1
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def play_turn
    valid_input = false
    until valid_input
      @board.display
      puts "#{@current_player.name}, choose a position (1-9) to place your faction emblem:"
      position = gets.chomp.to_i
      if position.between?(1, 9)
        row, col = (position - 1) / 3, (position - 1) % 3
        puts "Calculated Row: #{row}, Col: #{col}" # Diagnostic print
        valid_input = @board.place_faction(row, col, @current_player.faction)
      else
        puts "Invalid choice! Choose a number between 1 & 9"
      end
    end

    switch_player
  end

  def play
    until @board.victory? || @board.full?
      play_turn
    end

    if @board.victory?
      switch_player
      puts "#{@current_player.name} from #{@current_player.faction} wins!"
    else
      puts "It's a tie on Summoner's Rift!"
    end
  end
end

game = Game.new
game.play

# The game class organises the flow of the game.
# Its just is to integrate our 'Board' and 'Player' classes to manage our current game state.

# This class will contain methods for the following:
# --------------------------------------------------
# Initializing the game ('initialize' method) - sets up the board and the players.
# The ('switch_player' method) - toggles through our active players.
# The ('play_turn' method) - handles the players turns ensuring that they do choose a valid move.
# The ('play' method) - this is our main game loop where players take turns until a winner rises and the board is filled up with factions.



