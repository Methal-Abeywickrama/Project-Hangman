require 'yaml'
def get_word
  word_list = []
  dictionary_file = File.open("5desk.txt", "r")
  dictionary_file.each {|w| word_list.push w}
  word_list[rand(0..61402)]
end

def ask_for_save(game)
  puts "Do you want to save the game? (y/n)"
  response = gets.chomp.downcase
  if response == "y"
    File.open('save.dump', 'w') {|f| f.write(YAML.dump(game))}
  end
end

def display_as_a_string(array)
  array.join('')
end

def validate
  the_guess = gets.chomp
  if the_guess.length != 1
    until the_guess.length == 1
      puts "Please enter a letter"
      the_guess = gets.chomp
    end
  end
  the_guess
end

class Hangman
  attr_accessor :code, :display, :attempts, :won, :master
  def initialize
    @code = get_word.chomp.downcase.split("")
    @master = @code.clone
    @attempts = 15
    @display = []
    @won = false
    @code.length.times do
      @display.push("_")
    end
  end

  def check_win
      if @display.any?("_")
        @won = false
      else
        @won = true
      end
  end

  def guess(input)
    if !@code.select{|l| l == input}[0].nil?
      id = @code.index(@code.select{|l| l == input}[0])
      @display[id] = @code[id]
      @code[id] = "*"
      "Hey, You've got a letter #{input}"
    else 
      "No, #{input} wasn't a match"
    end
    self.check_win
  end
end

begin YAML.load(File.read('save.dump')).nil?
  puts "Would you like to continue where you left off?(y/n)"
  response = gets.chomp.downcase
  if response == 'y'
    hangman = YAML.load(File.read('save.dump'))
  else
    hangman = Hangman.new
  end
rescue
  puts "Hello, Let's play a game of hangman"
  hangman = Hangman.new
end


until hangman.attempts < 1 || hangman.won == true
  puts "You have #{hangman.attempts} left to crack the code"
  puts display_as_a_string(hangman.display)

  ask_for_save(hangman)

  puts "Enter your guess (A letter)"
  puts hangman.guess(validate)

  puts hangman.display.join('')
  hangman.attempts -= 1
end

if hangman.won == true
  puts "Hey, you found all the letters"
else
  puts "Ha ha ha, you lost the game. THE HANGMAN DIES!"
  puts "The correct answer was #{hangman.master.join('')}"
end

