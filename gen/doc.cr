# coding: utf-8

require "pretty"

dir   = ARGV.shift? || abort "arg1: dir not found"
label = ARGV.shift? || File.basename(dir)

lists = File.read_lines("#{dir}/list").map(&.chomp) # ["a", "b", "c"]
impls = File.read_lines("#{dir}/impl").map(&.chomp) # ["b"]
note  = File.read("#{dir}/note") rescue ""          # "a\tTODO\nc\tpending"

def note_for?(key : String, note : String) : String?
  note.scan(/^#{key}\t(.*?)$/m) do
    return $1
  end
  return nil
end

### Main

puts "# #{label}"

all = lists.size
ok  = (lists.to_set & impls.to_set).size
pct = (all == 0) ? 0 : (ok*100/all)

puts "## Implemented %d%% (%d/%d)" % [pct, ok, all]

lines = Array(Array(String)).new
lines << ["Name", "impl", "note"]
lines << ["-----", ":---:", "-----"]
lists.each do |key|
  name = "`#{key}`"
  impl = impls.includes?(key) ? "✓" : ""
  note = note_for?(key, note) || ""
  lines << [name, impl, note]
end

buf = Pretty.lines(lines, delimiter: "|")
buf.split(/\n/).each do |line|
  puts "|#{line}|"
end
