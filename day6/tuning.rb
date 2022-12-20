lines = File.read("./test-input.txt").lines.map(&:chomp)

MARKER = 14

lines.each do |line|
  index = (line.length - MARKER).times.find do |offset|
    segment = line[offset...(offset + MARKER)]
    # puts "#{segment}: #{segment.chars.uniq.count}"

    segment.chars.uniq.count == MARKER
  end

  puts "Found! #{index + MARKER}"

  a = 5
end
