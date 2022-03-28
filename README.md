# hangman
This take on hangman is built in Ruby using OOP. There are three classes - Game, Player, and Secret word. The secret word is randomly selected from an external dictionary. There is also a module that contains methods to enable game load/save. Game saving occurs by serializing instance variables to YAML format, and loading is the reverse, setting instance variables to the values in a YAML file. 

A player can choose to start a new game or load a game. 
If they start a new game, they have 8 chances to guess the correct letters. User entries are validated to make sure they are letters, and a history of correct and incorrect guesses is provided.
If they want to load a game, the existing saved files are displayed and they enter the one they want to continue playing. 

You can play online at: https://replit.com/@BenJ8/hangman#main.rb

