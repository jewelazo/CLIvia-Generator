module Requester
  def select_main_menu_action
    gets_option "> ", "invalid option", nil, %w[random scores exit], " | "
  end

  def ask_question(quest)
    options = feature(quest)
    n = ("1"..options.size.to_s)
    options_u = options.sort_by { rand }
    dic = n.zip(options_u).to_h
    dic.each { |k, v| puts "#{k}. #{v}" }
    input = gets_option("> ", "invalid option", nil, n, nil)
    [input, dic]
  end

  def feature(quest)
    puts "Category: #{quest[:category]} | Difficulty: #{quest[:difficulty]}"
    puts "Question: #{HTMLEntities.new.decode quest[:question]}"
    array = []
    array[0] = quest[:correct_answer]
    options = array.concat(quest[:incorrect_answers])
    options.map { |str| HTMLEntities.new.decode(str) }
  end

  def will_save?
    puts "Well done! Your score is #{@score}"
    save = gets_option(nil, "invalid option", "Do you want to save your score? y/n ", %w[y n], nil)
    return unless save != "n"

    puts "Type the name to assign to the score"
    print "> "
    name = gets.chomp
    name = "Anonymous" unless name != ""
    @score_data << { name: name, score: @score }
    File.open(@filename, "w") do |json|
      json.write(@score_data.to_json)
    end
  end

  def get_number(rango)
    gets_option("> ", "invalid option", nil, rango, nil)
  end

  def gets_option(prompt, message1, message2, options, format)
    puts options.join(format) unless format.nil?
    print message2 unless message2.nil?
    print prompt unless prompt.nil?
    input = gets.chomp.strip.downcase
    until options.include?(input)
      puts message1
      print message2 unless message2.nil?
      print prompt
      input = gets.chomp.strip.downcase
    end
    input
  end
end
