# Methods to get filename, serialize to YAML, load game from YAML. All called by Game class.
module Serialize
  # check if there is a saved games folder, if so, display file names, get name and pass to load_yaml
  # otherwise send player back to start
  def load_game
    if File.exist?('./saved_games')
      puts "Saved files: #{Dir.children('./saved_games').join(' ')}"
      puts 'Enter one of the filenames "filename.yml"'
      filename = gets.chomp
      from_yaml(filename)
    else
      puts 'There are no files to load. You have to play a new game.'
      load_or_new
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

  def from_yaml(filename)
    f = YAML.load(File.read("./saved_games/#{filename}"))
    @word = f[:word]
    @display = f[:display]
    @life = f[:life]
    @player.misses = f[:player_misses]
    @player.guess_history = f[:player_guess_history]
  end
end
