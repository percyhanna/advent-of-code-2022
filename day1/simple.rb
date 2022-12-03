lines = File.read("./input.txt").lines

biggest_number = 0
total = 0
lines.each do |line|
  if line.chomp.empty?
    puts "Elf had #{total} calories"
    if total < biggest_number
      # throw away
    else
      biggest_number = total
    end
    total = 0
  else
    number = line.chomp.to_i
    total += number
  end
end

puts "Biggest number is #{biggest_number}"
