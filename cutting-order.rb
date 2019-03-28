#!/usr/bin/env ruby --encoding macroman

# arguments to the script are (number of sheets per batch), (number of cards to a sheet)
sheets, cards_per_sheet = ARGV.map(&:to_i)

# check arguments
if sheets.nil? || sheets == 0 || cards_per_sheet.nil? || cards_per_sheet == 0
	puts "Usage: #{$0} sheets_per_batch cards_per_sheet"
	exit 1 
end

cards = sheets * cards_per_sheet

# skip the header row by reading it in and spitting it straight out
$stdout.puts $stdin.gets

# now repeat until end of file
until $stdin.eof?
	# read in a full batch of cards
	inlines = (0...cards).map { $stdin.gets }

	# spit them out in the right order
	(0...sheets).each do |sheet|
		(sheet...cards).step(sheets) do |index|
			$stdout.puts(inlines[index] || '—')
		end
	end
end
