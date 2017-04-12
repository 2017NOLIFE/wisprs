Dir.glob("#{File.dirname(_FILE_)}/*.rb").each do |file|
	require file
end