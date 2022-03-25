module Methods
end

# class to instantiate Player and Secretword, and methods provide game logic
class Game
  attr_accessor :word, :player

  def initialize
    @word = SecretWord.new
    @player = Player.new
    @display = ''
    @life = 8
  end

  # make underscores based on secret word length
  def make_display
    length = word.choice.strip!.length
    @display = Array.new(length, '_')
    puts "\nA mystery word has been selected. Godspeed.\n"
    puts @display.join(' ')
    puts "\n"
  end

  # check if player has guessed secret word
  def check_winner
    if @display == @word.choice.split(//)
      puts "Congrats! you guessed the word.\n"
      @life = 0
    elsif @life.zero?
      puts "Better luck next time! The word was '#{@word.choice}'."
    end
  end

  # check to see if player guess matches letter in secret word
  def match
    if @word.choice.include?(@player.guess)
      word_array = @word.choice.split(//)
      word_array.each_with_index do |letter, index|
        @display[index] = letter if letter == @player.guess
      end
      puts "\nPhew, #{@player.name} '#{@player.guess}' is in the word."
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
    puts "\nSorry, #{@player.name} '#{@player.guess}' is not in the word.\n"
    puts "Misses: #{player.misses.join(', ')}\n"
    @life -= 1
    puts @display.join(' ')
    puts "\n"
  end

  # allow game replay
  def replay
    puts 'Enter "y" to play again.'
    response = gets.chomp
    if response == 'Y' || response == 'y'
      @word = SecretWord.new
      @player = Player.new
      @life = 8
      play_game
    else
      puts "Thanks for playing!"
    end
  end

  def play_game
    @word.select_word
    puts @word.choice
    make_display
    until @life.zero?
      puts "Life left: #{@life}"
      @player.player_guess
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
      if word.length >= 5 && word.length <= 12
        word_array << word
      end
    end
    @choice = word_array.sample
  end
end

# Class to prompt guesses, validate them, store them, and store player name.
class Player
  attr_accessor :guess, :name, :misses

  def initialize
    puts 'Please enter your name.'
    @name = gets.chomp
    @guess = ''
    @misses = []
    @guess_history = []
  end

  # get player input and loop until it meets requirements
  def player_guess
    puts "#{@name}, enter your guess (one letter a - z)."
    input = gets.chomp.downcase
    until input.length == 1 && input =~ /[a-z]/
      puts "\n#{@name}! Enter a valid guess (one letter a - z)."
      input = gets.chomp.downcase
    end
    @guess = input
    check_history(input)
    @guess_history << @guess
  end

  # check to see if player has already entered a given letter
  def check_history(input)
    if @guess_history.include?(input)
      puts "You've already tried that one!"
      player_guess
    else
      false
    end
  end
end

puts 'Welcome to terminal hangman. You get 8 attempts to guess the word. Good luck!'
test = Game.new
test.play_game