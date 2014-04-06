class Hangman

  MAX_GUESSES = 7
  attr_reader :guesser, :picker

  def initialize(guesser, picker)
    @guesser = guesser
    @picker = picker
  end

  def play
    word_length = @picker.pick_secret_word
    @guesser.receive_secret_length(word_length)

    current_state = ["_"] * word_length
    guessed_letters = []
    guess_count = 0
    until won?(current_state) || guess_count > MAX_GUESSES
      puts "------------------------------------"
      display_state(current_state)

      begin
        guessed_letter = @guesser.guess
        puts "Already guessed '#{guessed_letter}'" if guessed_letters.include?(guessed_letter)
      end while guessed_letters.include?(guessed_letter)

      guessed_letters << guessed_letter
      response = @picker.check_guess(guessed_letter)

      if response.empty?
        guess_count +=1
        puts "Wrong guess."
      else
        response.each { |ind| current_state[ind] = guessed_letter }
        puts "Correct guess"
      end

      @guesser.handle_guess_response(response, guessed_letter)
    end

    if won?(current_state)
    puts "The word was '#{current_state.join}'!"
    else
      puts "The word was not guessed!"
    end
  end

  def won?(current_state)
    !current_state.any? { |el| el == "_" }
  end

  def display_state(state)
    puts "Secret word: #{state.join}"
  end

end

class HumanPlayer

  def pick_secret_word
    puts "Pick a word.  How long is it?"
    gets.chomp.strip.to_i
  end

  def receive_secret_length(word_length)
    puts "The word is #{word_length} letters long."
  end

  def guess
    print "Guess a letter: "
    gets.chomp.strip.downcase
  end

  def check_guess(guessed_letter)
    puts "The other player guessed #{guessed_letter}"
    puts "Enter the position(s) of the letter (Press 'Enter' if none)"
    inds = gets.chomp.split(",")
    inds.map { |ind| ind.to_i - 1 }
  end

  def handle_guess_response(response, guessed_letter)

  end
end

class ComputerPlayer

  attr_accessor :word, :dict
  attr_reader :guessed_letters

  def initialize
    @dict = nil
    @word = nil
    @guessed_letters = []
  end

  def pick_secret_word
    self.word = intake_dict('./dictionary.txt').sample
    self.word.length
  end

  def intake_dict(file)
    self.dict = File.readlines(file).map { |word| word.chomp }
  end

  def receive_secret_length(word_length)
    self.dict = intake_dict('./dictionary.txt')
    self.dict.select!{ | dict_word | dict_word.length == word_length }
  end

  def guess
    begin
      letter = self.dict.sample.split(//).sample
    end until letter =~ /[a-z]/
    guessed_letters << letter
    letter
  end

  def check_guess(guessed_letter)
    correct_inds = []

    self.word.split(//).each_with_index do |letter, ind|
      correct_inds << ind if letter == guessed_letter
    end

    correct_inds
  end

  def handle_guess_response(response, letter)
    if response.empty?
      self.dict.reject! { |word| word =~ /\A.+[#{letter}].+/ }
      p "Wrong resp: #{self.dict.length}"
    else
      response.each do |ind|
        self.dict.select! { |word| word =~ /\A.{#{ind}}[#{letter}]/ }
        p "Correct resp: #{self.dict.length}"
      end
    end
  end
end

