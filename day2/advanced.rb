THEIR_CHOICES = {
  "A" => "Rock",
  "B" => "Paper",
  "C" => "Scissor",
}

MY_CHOICES = {
  "X" => "Rock",
  "Y" => "Paper",
  "Z" => "Scissor",
}

POINTS = {
  "Rock" => 1,
  "Paper" => 2,
  "Scissor" => 3,
}

def win?(their_choice, my_choice)
  case their_choice
  when "Rock"
    my_choice == "Paper"
  when "Paper"
    my_choice == "Scissor"
  when "Scissor"
    my_choice == "Rock"
  else
    raise "Invalid game"
  end
end

def score(their_choice, my_choice)
  game_score =
    if their_choice == my_choice
      3
    elsif win?(their_choice, my_choice)
      6
    else
      0
    end

  choice_points = POINTS[my_choice]

  game_score + choice_points
end

lines = File.read("./input.txt").lines

scores = lines.map do |line|
  their_code, my_code = line.split(" ")
  their_choice = THEIR_CHOICES[their_code]
  my_choice = MY_CHOICES[my_code]

  game_score = score(their_choice, my_choice)
  puts "#{their_choice}\t#{my_choice}:   \t#{game_score}"

  game_score
end

puts scores.sum
