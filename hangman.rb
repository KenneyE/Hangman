class Hangman
  def initalize
    @dictionary = intake_dict('./dictionary.txt')

  end

  def intake_dict(file)
    dictionary = File.readlines(file).chomp
  end


end

class ComputerPlayer

end