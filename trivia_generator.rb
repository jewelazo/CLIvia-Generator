# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
# rubocop:disable Style/GuardClause,Metrics/AbcSize
require_relative "./presenter"
require_relative "./requester"
require_relative "./services/opentdb"
require "json"
require "terminal-table"

class TriviaGenerator
  include Presenter
  include Requester
  # maybe we need to include a couple of modules?

  def initialize(filename = "scores.json")
    @score = 0
    # @score_data = []
    @filename = filename
    @score_data = JSON.parse(File.read(@filename), symbolize_names: true)
    # we need to initialize a couple of properties here
  end

  def start
    print_welcome
    action = select_main_menu_action
    until action == "exit"
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      end
      print_welcome
      action = select_main_menu_action
    end
    File.open("scores.json", "w") do |json|
      json.write(@score_data.to_json)
    end
    print_exit
  end

  def random_trivia
    questions = parse_questions[:results]
    questions.each do |q|
      puts "Category: #{q[:category]} | Difficulty: #{q[:difficulty]}"
      puts "Question: #{q[:question]}"
      array = []
      array[0] = q[:correct_answer]
      options = array.concat(q[:incorrect_answers])
      n = (1..options.size)
      options_u = options.sort_by { rand }
      dic = n.zip(options_u).to_h
      dic.each { |k, v| puts "#{k}. #{v}" }
      print "> "
      input = gets.chomp.to_i
      # until (1..options_u.size)include?(input)
      #   puts "invalid option"
      #   print "> "
      #   input=gets.chomp.to_i
      # end
      if dic[input].match?(/#{q[:correct_answer]}/)
        @score += 10
      else
        puts "#{dic[input]}...Incorrect!"
        puts "The correct answer was: #{q[:correct_answer]}"
      end
    end
    puts "Well done! Your score is #{@score}"
    save(@score)
    @score = 0
  end

  def ask_questions
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
  end

  def save(_data)
    puts "--------------------------------------------------"
    print "Do you want to save your score? y/n "
    save = gets.chomp.downcase
    alt = %w[y n]
    until alt.include?(save)
      puts "Invalid option"
      print "Do you want to save your score? y/n "
      save = gets.chomp.downcase
    end
    if save != "n"
      puts "Type the name to assign to the score"
      print "> "
      name = gets.chomp
      name = "Anonymous" unless name != ""
      @score_data << { name: name, score: @score }
    end
  end
  # write to file the scores data

  def parse_scores
    # get the scores data from file
  end

  def load_questions
    Opentdb.index
    # ask the api for a random set of questions
  end

  def parse_questions
    load_response = load_questions
    JSON.parse(load_response.body, symbolize_names: true)
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end

  def print_scores
    database = @score_data
    table = Terminal::Table.new
    table.title = "Top Scores"
    table.headings = %w[Name Score]
    table.rows = database.map do |row|
      [row[:name], row[:score]]
    end
    puts table
  end
  #   # print the scores sorted from top to bottom
  # end
end

trivia = TriviaGenerator.new
trivia.start
# rubocop:enable Style/GuardClause,Metrics/AbcSize
