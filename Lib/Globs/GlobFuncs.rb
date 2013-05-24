def terminate
	print "use Globs.terminate"
	return
  $terminate = true
end

def clear_temp_directory
	print "use Globs.clear_temp_directory"
	return
  files = read_files_recursive("Shared/Temp")
  files.each { |file|
    File.delete("Shared/Temp/" + file)
  }
end

def read_files_recursive(dir)
	print "use globs read files"
	return
  files = []
  Dir.foreach(dir) { |file|
    next if file == "." || file == ".."
    begin
      read_files_recursive(dir + "/" + file) if file.match(/\./).nil?
    rescue Errno::ENOENT
      # Supplement Errno::ENOENT exception
      # If unable to open file, display message and end
      filename = $!.message.sub("No such file or directory - ", "")
      
      $log.log(false, :warning, "Unable to find file #{filename}.")
    end
    files << file
  }
  files
end

def filter_threads
	print "use globs filter threads"
	return
  deads = []
  $threads.each { |th|
    deads << th unless th.status == "run"
  }
  deads.each { |th|
    $threads.delete th
  }
end