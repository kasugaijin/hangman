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