require_relative "./presenter"
require_relative "./requester"
require_relative "./services/opentdb"
require "json"
require "terminal-table"
require "htmlentities"

class TriviaGenerator
  include Presenter
  include Requester
  def initialize(filename = "scores.json")
    @score = 0
    @filename = filename
    @score_data = JSON.parse(File.read(@filename), symbolize_names: true)
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
    print_exit
  end

  def random_trivia
    questions = parse_questions[:results]
    ask_questions(questions)
    save
    @score = 0
  end

  def ask_questions(questions)
    questions.each do |q|
      input, dic = ask_question(q)
      if dic[input].match?(/#{q[:correct_answer]}/)
        @score += 10
        puts "Correct answer!!!"
      else
        puts "#{dic[input]}...Incorrect!"
        puts "The correct answer was: #{q[:correct_answer]}"
      end
    end
  end

  def save
    puts "--------------------------------------------------"
    will_save?
  end

  def load_questions
    Opentdb.index
  end

  def parse_questions
    load_response = load_questions
    JSON.parse(load_response.body, symbolize_names: true)
  end

  def print_scores
    database = (@score_data.sort_by { |k| k[:score] }).reverse[0..4]
    table = Terminal::Table.new
    table.title = "Top Scores"
    table.headings = %w[Name Score]
    table.rows = database.map do |row|
      [row[:name], row[:score]]
    end
    puts table
  end
end

trivia = TriviaGenerator.new
trivia.start
