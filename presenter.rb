module Presenter
  def print_welcome
    # print the welcome message
    message = ["###################################",
               "#   Welcome to Trivia Generator   #",
               "###################################"].join("\n")
    puts message
  end

  def print_score(score)
    # print the score message
  end

  def print_exit
    # print the welcome message
    message = ["####################################",
               "# Thanks for play Trivia Generator #",
               "####################################"].join("\n")
    puts message
  end
end
