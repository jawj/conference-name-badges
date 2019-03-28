#!/usr/bin/env ruby --encoding macroman

# skip the header row by reading it in and spitting it straight out
$stdout.puts $stdin.gets

# now repeat until end of file
until $stdin.eof?

	# read 6 lines
	inlines = (0..5).map { $stdin.gets }

	# spit them out, first in the original order,
	# and then again after switching adjacent pairs
	[0, 1, 
	 2, 3, 
	 4, 5, 
	 1, 0, 
	 3, 2, 
	 5, 4].each { |index| $stdout.puts(inlines[index] || '—') }
end
