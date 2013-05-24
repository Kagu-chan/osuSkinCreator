# This file contains the Thread module which contains functions to run in seperate theads.
print "note kagu - Lib::Threads!"
module Threads
  
	# Entry point for the application. Run all other functions. If this thread ending, the application shut down
  def self.run_main_handle
		$log.log(false, :info, "Threads: run_main_handle")
    $threads << Thread.new(0) {
			$th___run_main_handle = false
      begin
        Globs.main
        $notes_graph.dispose
        $terminate = true
      rescue => e
        Thread.main.raise e
      end
			$th___run_main_handle = true
    }
  end
  
	# Update notes on screen
  def self.run_notes_update_handle
		$log.log(false, :info, "Threads: run_notes_update_handle")
    $threads << Thread.new(1) {
			$th___run_notes_update_handle = false
      begin
        loop do
          $notes_graph.update
        end
      rescue => e
        Thread.main.raise e
      end
			$th___run_notes_update_handle = true
    }
  end
  
  def self.run_set_up
		$log.log(false, :info, "Threads: run_set_up")
    $threads << Thread.new(2) {
			$th___run_set_up = false
      begin
        Globs.setup_engine
      rescue => e
        Thread.main.raise e
      end
			$th___run_set_up = true
    }
  end
  
  def self.osu_skin_reader_run
		print "no function! use External::Threads.run_skin_reader"
  end
  
  def self.read_skin_cache
		$log.log(false, :info, "Threads: read_skin_cache")
    $threads << Thread.new(4) {
			$th___read_skin_cache = false
      begin
        Load.load_file_list
        $notes << $lang[:skin_lib_loaded]
        sleep 3
        $notes.clear
      rescue => e
        Thread.main.raise e
      end
			$th___read_skin_cache = true
    }
  end
  
	# Filter threads by living and dead threads to ensure that we dont get a overflow of threads
  def self.run_thread_filter_handle
		$log.log(false, :info, "Threads: run_thread_filter_handle")
    $threads << Thread.new(5) {
			$th___run_thread_filter_handle = false
      begin
        loop do
          sleep 5
          Globs.filter_threads
        end
      rescue => e
        Thread.main.raise e
      end
			$th___run_thread_filter_handle = true
    }
  end
  
  def self.update_skin_lib
		$log.log(false, :info, "Threads: update_skin_lib")
    $threads << Thread.new(6) {
			$th___update_skin_lib = false
      begin
        File.delete("Shared/Temp/osrFinnished.skd") if FileTest.exist? "Shared/Temp/osrFinnished.skd"
        sleep 1
				
        External::Threads.run_skin_reader
        
        while !FileTest.exist?("Shared/Temp/osrFinnished.skd")
          files = Globs.read_files_recursive "Shared/Temp"
					found = files[0]
					if found.nil?
						sleep 1
						next
					end
					
					found.match("([0-9]*)")
					next if $1 == ""
					
          $notes = ["#{$lang[:load_and_sort]} #{$1} #{$lang[:files_found]}"]
        end
        
      rescue => e
        Thread.main.raise e
      end
			$th___update_skin_lib = true
    }
  end
  
end