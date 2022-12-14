commands = File.read("./test-input.txt").lines.map(&:chomp)
commands = File.read("./input.txt").lines.map(&:chomp)

TOTAL_SPACE = 70_000_000
SPACE_NEEDED = 30_000_000

dirs = Hash.new { |hash, key| hash[key] = 0 }
cwd = "/"
commands.each do |command|
  case command
  when "$ cd /"
    cwd = "/"
  when "$ cd .."
    segments = "/#{cwd}".split("/")
    segments.pop
    cwd = "#{segments.join("/")[1..]}/"
  when /\A\$ cd (.*)\z/
    cwd += "#{$1}/"

    # Create an empty dir, some dirs only have other dirs
    dirs[cwd] ||= 0
  when /\Adir.*\z/
    # we can ignore this, useless
  when /\A(\d+) (.+)/
    dirs[cwd] += $1.to_i
  when /\$ ls/
    # nothing, will start reading dir entries
  else
    raise "Unmatched command: #{command}"
  end
end

dir_totals = dirs.dup
dirs.keys.each do |parent|
  dir_totals[parent] = dirs.keys.select do |dir|
    dir.start_with?(parent)
  end.map { |dir| dirs[dir] }.sum
end

puts(dir_totals.values.select { |size| size < 100_000 }.sum)

space_available = TOTAL_SPACE - dir_totals["/"]
size_to_delete = SPACE_NEEDED - space_available

puts "TOTAL_SPACE: #{TOTAL_SPACE}"
puts "SPACE_NEEDED: #{SPACE_NEEDED}"
puts "space_available: #{space_available}"
puts "all files: #{dir_totals["/"]}"
puts "size_to_delete: #{size_to_delete}"

puts(dir_totals.select { |dir, size| size > size_to_delete }.sort_by { |dir, size| size }.first)
