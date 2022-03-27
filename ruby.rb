require 'yaml'

# class to instantiate Player and Secretword, and methods provide game logic
class Game
  attr_accessor :word, :player, :display, :life

  def initialize
    @word = SecretWord.new
    @player = Player.new
    @display = ''
    @life = 8
    load_or_new
  end

  # if new game, create secret word before play, else load saved game before play
  def load_or_new
    puts 'Enter "1" for a new game or "2" to load a saved game.'
    input = gets.chomp
    if input == '1'
      @word.select_word
      play_game
    else
      load_game
      puts @display.join(' ')
      play_game
    end
  end

  # make underscores based on secret word length
  def make_display
    if @display == ''
      length = word.choice.strip!.length
      @display = Array.new(length, '_')
      puts "\nA secret word awaits. Godspeed.\n"
      puts @display.join(' ')
      puts "\n"
    else
      false
    end
  end

  # check if player has guessed secret word
  def check_winner
    if @display == @word.choice.split(//)
      puts "Congrats! you win.\n"
      @life = 0
    elsif @life.zero?
      puts "Unlucky! The word was '#{@word.choice}'."
    end
  end

  # check if 'save' entered and get desired file name
  def save_game
    if player.guess == 'save'
      puts 'Enter a file name (no spaces).'
      filename = gets.chomp
      to_yaml(filename)
    end
  end

  # make directory if it does not exist, create file using user's file name
  # convert to YAML and close the file
  def to_yaml(filename)
    Dir.mkdir('saved_games') unless File.exist?('saved_games')
    f = File.open("saved_games/#{filename}.yml", 'w')
    YAML.dump({
      :word => @word,
      :display => @display,
      :life => @life, 
      :player_misses => @player.misses,
      :player_guess_history => @player.guess_history
    }, f)
    f.close
  end

  # get file name to load and pass into 'from YAML' method
  def load_game
    puts 'Enter the filename (no spaces).'
    filename = gets.chomp
    from_yaml(filename)
  end

  def from_yaml(filename)
    f = YAML.load(File.read("./saved_games/#{filename}.yml"))
    @word = f[:word]
    @display = f[:display]
    @life = f[:life]
    @player.misses = f[:player_misses]
    @player.guess_history = f[:player_guess_history]
  end

  # check to see if player guess matches letter in secret word
  def match
    if @word.choice.include?(@player.guess)
      word_array = @word.choice.split(//)
      word_array.each_with_index do |letter, index|
        @display[index] = letter if letter == @player.guess
      end
      puts "\nPhew, '#{@player.guess}' is in the word."
      puts "\n"
      puts @display.join(' ')
      puts "\n"
    else
      miss
    end
  end

  # if wrong guess add to "misses" history
  def miss
    player.misses << @player.guess
    puts "\n'#{@player.guess}' is not in the word.\n"
    puts "Misses: #{player.misses.join(', ')}\n"
    @life -= 1
    puts @display.join(' ')
    puts "\n"
  end

  # allow game replay
  def replay
    puts 'Enter "y" to play again.'
    response = gets.chomp.downcase
    if response == 'y'
      new_game
    else
      puts 'Thanks for playing!'
    end
  end

  def new_game
    new = Game.new
    new.play_game
  end

  def play_game
    puts @word.choice
    make_display
    until @life.zero?
      puts "Life left: #{@life}"
      @player.player_input
      save_game
      match
      check_winner
    end
    replay
  end
end

# class to create and store secret word
class SecretWord
  attr_accessor :choice

  def initialize
    @choice
  end

  # pulls words (5-12 characters) from file and selects a random word for secret word
  def select_word
    word_array = []
    word_list = File.open('./google-10000-english-no-swears.txt')
    word_list.each do |word|
      word_array << word if word.length >= 5 && word.length <= 12
    end
    @choice = word_array.sample
  end
end

# Class to prompt guesses, validate them, store them.
class Player
  attr_accessor :guess, :misses, :guess_history

  def initialize
    @guess = ''
    @misses = []
    @guess_history = []
  end

  # get player input and pass to valdation method, unless save.
  def player_input
    puts "Enter your guess (one letter a - z), or 'save' to save."
    input = gets.chomp.downcase
    if input == 'save'
      @guess = input
    else
      validate_input(input)
    end
  end

  # default parameter value is blank in case check history finds the letter has been used
  def validate_input(input = '')
    until input.length == 1 && input =~ /[a-z]/
      puts "\nEnter a valid guess (one letter a - z)."
      input = gets.chomp.downcase
    end
    @guess = input
    check_history(input)
    @guess_history << @guess
  end

  # if player has already entered a given letter, call validate_input with no argument to restart loop
  def check_history(input)
    if @guess_history.include?(input)
      puts "You've already tried that one!"
      validate_input
    else
      false
    end
  end
end

puts 'Welcome to terminal hangman. You get 8 attempts to guess the word. Good luck!'

Game.new