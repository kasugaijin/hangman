class Game
  attr_accessor :word, :player

  def initialize
    @word = SecretWord.new
    @player = Player.new
    @display = ''
    @turn = 1
    @misses = []
  end

  # make underscores
  def make_display
    length = word.choice.strip!.length
    @display = Array.new(length, '_')
    puts "\nA mystery word has been selected. Godspeed.\n"
    puts @display.join(' ')
  end

  def check_winner
    if @display == @word.choice.split(//)
      puts 'Congrats! you guessed the word.'
      @turn = 9
    end
  end

  def match
    if @word.choice.include?(@player.guess)
      word_array = @word.choice.split(//)
      word_array.each_with_index do |letter, index|
        @display[index] = letter if letter == @player.guess
      end
      puts "Phew #{@player.name}, '#{@player.guess}' is in the word.'\n'"
      puts @display.join(' ')
      @turn += 1
    else
      self.miss
    end
  end

  def miss
    @misses << @player.guess
    puts "Sorry, #{@player.name} '#{@player.guess}' is not in the word.\n"
    puts "Misses: #{@misses.join(', ')}"
    @turn += 1
    puts @display.join(' ')
    puts "\n"
  end

  def play_game
    @word.select_word
    puts @word.choice
    make_display
    until @turn >= 9
      @player.player_guess
      match
      check_winner
    end
    # replay?
  end
  # replay - all you need to do is set a new instance of SecretWord
end

class SecretWord

  attr_accessor :choice

  def initialize
    @choice
  end

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

class Player
  
  attr_accessor :guess, :name

  def initialize
    puts 'Please enter your name.'
    @name = gets.chomp
    @guess = ''
    @turn = 1
  end

  def player_guess
    puts "\nTurn: #{@turn}"
    puts "#{@name}, enter your guess (one letter a - z)."
    input = gets.chomp.downcase
    until input.length == 1 && input =~ /[a-z]/
      puts "#{@name}! Enter a valid guess (one letter a - z)."
      input = gets.chomp.downcase
    end
    @guess = input
    @turn += 1
  end
end

puts 'Welcome to terminal hangman. You get 8 attempts to guess the word. Good luck!'
test = Game.new
test.play_game