# This file contains the Thread module which contains functions to run in seperate theads.

module System

	module Threads
		
		# Entry point for the application. Run all other functions. If this thread ending, the application shut down
		def self.run_main_handle
			$log.log(false, :info, "Threads: run_main_handle")
			$threads << Thread.new(0) {
				$th___run_main_handle = false
				begin
					System::Globs.main
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
					System::Globs.setup_engine
				rescue => e
					Thread.main.raise e
				end
				$th___run_set_up = true
			}
		end
		
		def self.read_skin_cache
			$log.log(false, :info, "Threads: read_skin_cache")
			$threads << Thread.new(4) {
				$th___read_skin_cache = false
				begin
					System::Loads.load_file_list
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
						System::Globs.filter_threads
					end
				rescue => e
					Thread.main.raise e
				end
				$th___run_thread_filter_handle = true
			}
		end
		
		def self.update_skin_lib(available=false)
			$log.log(false, :info, "Threads: update_skin_lib")
			$threads << Thread.new(6) {
				$th___update_skin_lib = false
				begin
					$notes << "Wating for skinfiles..."
					
					Interfacing::TaskHandler.analize if !available
					
					loop { break if Interfacing::NotesHandler.skin_available? || available }
					
					Interfacing::TaskHandler.copy($user_name)
					
					$notes << "Copy skindata to userfolder..."
					
					loop { break if Interfacing::NotesHandler.data_copied? }
				rescue => e
					Thread.main.raise e
				end
				$th___update_skin_lib = true
			}
		end
		
		def self.run_infobox_handle
			$log.log(false, :info, "Threads: run_infobox_handle")
			
			$threads << Thread.new(3) {
				$th___run_infobox_handle = false
				begin
					loop {
						InfoBox_Collection.instance.each_pair{ |key, value|
							if value.has_info_text? && !value.box.nil?
								begin; value.box.update unless value.box.disposed?;	rescue; end
							end
						}
					}
					sleep 2
				rescue => e
					Thread.main.raise(e)
				end
				$th___run_infobox_handle = true
			}
		end
		
	end

end