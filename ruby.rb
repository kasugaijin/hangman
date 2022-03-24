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
    @display.join(' ')
  end

  def check_winner
    if @display == @word.choice.split(//)
      puts 'Congrats! you guessed the word.'
      @turn = 12
    end
  end

  def match
    if @word.choice.include?(@player.guess)
      word_array = @word.choice.split(//)
      word_array.each_with_index do |letter, index|
        @display[index] = letter if letter == @player.guess
      end
      puts "Yay #{@player.name}! '#{@player.guess}' is in the word. '\n'"
      puts @display.join(' ')
      @turn += 1
    else
      self.miss
    end
  end

  def miss
    @misses << @player.guess
    puts "Sorry, #{@player.name} '#{@player.guess}' is not in the word. '\n'"
    puts "Misses: #{@misses.join(', ')}"
    @turn += 1
    # puts @display.join(' ')
  end

  # play game
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
  end

  def player_guess
    puts "\n#{@name}, enter your guess (one letter a - z)."
    input = gets.chomp.downcase
    until input.length == 1 && input =~ /[a-z]/
      puts "#{@name}! Enter a valid guess (one letter a - z)."
      input = gets.chomp.downcase
    end
    @guess = input
  end
end


test = Game.new
# game.playgame

# playgame
test.word.select_word
puts test.word.choice
puts test.make_display
test.player.player_guess
test.match