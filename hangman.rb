class Hangman

  MAX_GUESSES = 7

  def initalize
  end

  def play
    @guesser = HumanPlayer.new
    @picker  = ComputerPlayer.new


    word_length = @picker.pick_secret_word
    @guesser.receive_secret_length(word_length)

    current_state = ["_"] * word_length
    guess_count = 0
    if won?(current_state) && guess_count <= MAX_GUESSES

      display_state(current_state)

      guessed_letter = @guesser.guess
      response = @picker.check_guess(guessed_letter)


      if response.empty?
        guess_count +=1
      else
        response.each { |ind| current_state[ind] = guessed_letter }
      end

      @guesser.handle_guess_response(response, guessed_letter)

    end

    puts "The word was guessed!" unless won?(current_state)
  end

  def won?(current_state)
    !current_state.any? { |el| el == "_" }
  end

  def display_state(state)
    puts "Secret word: #{state.join}"
  end

end

def HumanPlayer

  def pick_secret_word
    puts "Pick a word.  How long is it?"
    gets.chomp.strip.to_i
  end

end

class ComputerPlayer

  attr_accessor :word
  attr_reader :dict

  def initialize
    @dict = intake_dict('./dictionary.txt')
    @word = nil
  end

  def pick_secret_word
    word = dict.sample
    word.length
  end

  def intake_dict(file)
    dictionary = File.readlines(file).chomp
  end

  def receive_secret_length(word_length)
    dict.select!{ | word | word.length == word_length }
  end

  def guess
    dict.sample.split(//).sample
  end

  def check_guess(guessed_letter)
    correct_inds = []

    word.each_with_index { |letter, ind| correct_inds << ind if word.include?(letter) }

    correct_inds
  end

  def handle_guess_response(response, guessed_letter)
    response.each do |ind|
      dict.select! { |word| word =~ /\A.{ind-1}[letter]/ }
    end
  end
end

