# This file contains the Globs-Module. This module handles all operations which could called from everywhere

module System

	module Globs
		
		# Programm entry point!
		def self.run_application
			begin
				System::Globs::Initialization.ensure_user_dir
				System::Globs::Initialization.set_variables
				System::Threads.run_main_handle
				System::Threads.run_notes_update_handle
				System::Threads.run_thread_filter_handle
				
				while !$terminate; end
			rescue => e
				$log.log(true, :error, e.message)
				
				# Herausfinden, in welcher Zeile der Fehler aufgetreten ist
				e.backtrace[0].match(/:([0-9]*):/)
				line = $1
				
				# Herausfinden, in welchem Skript der Fehler aufgetreten ist
				e.inspect.match(/\s#<(.*):/)
				come_from = $1
				
				$log.log(false, :error, e.message, come_from, line)
				$log.write_detail(e)
				
				print e.message
			end
		end
		
		# Setup the engine, such as language or settings files
		def self.setup_engine
			$log.log(false, :info, "Globs: setup_engine")
			
			$notes << $lang[:load_engine]
			System::Loads.load_language_file
			System::Loads.load_settings
			System::Globs.clear_temp_directory
			System::Globs.set_osu_dir
			$bg_past.bitmap = Bitmap.new($default_bg)
			
			$notes.clear
		end
		
		# Sets the $user_name variable
		def self.set_user_name
			api = Win32API.new('advapi32',"GetUserName",['p','p'],'i')
			name = " " * 128
			api.call(name,"128")
			
			$user_name = name.unpack("A*").first
		end
		
		# Secure that the user names folder exist and creates the default settings files. 
		def self.secure_folder
			unless FileTest.exist? $user_name
				Dir.mkdir($user_name)
				Dir.mkdir($user_name + "/SkinData")
				
				File.copy("Lib/SharedElements/startup.ini", $user_name + "/startup.ini")
				File.copy("Lib/SharedElements/usersettings.ini", $user_name + "/usersettings.ini")
				
				$first_run = true
			end
			
			# Following code is not in base condition - version specified changes
			
			# v0.2
			Dir.mkdir($user_name + "/OSC_Skin") unless FileTest.exist?($user_name + "/OSC_Skin")
		end
		
		# Programm main handle. Running scenes and manage exceptions
		def self.main
			$log.log(false, :info, "Globs: main")
			# Log-Variable erstellen und Stream öffnen
			
			$log.log(false, :info, "started application and opened stream", "Main", "main")
			
			# Setzt die aktuelle Start-Scene
			$current_scene = Excp.start_scene
			$scene_now = nil
			
			# Alle Operationen in einem Loop ausführen, solange Scene nicht explizit
			# auf nil gesetzt wird.
			# So wird das Spiel nach einem Fehler nicht beendet.
			$scene = false
			while $scene != nil
				
				begin
					# Prepare for transition
					Graphics.freeze
					# Make scene object
					operation = "$scene = Scenes::" + $current_scene.to_s + ".new"
					proc = Proc.new() { eval(operation) }
					
					begin
						proc.call
					rescue
						operation = "$scene = Scenes::Errors::" + $current_scene.to_s + ".new"
						proc = Proc.new() { eval(operation) }
						begin
							proc.call
						rescue
							print $!.message
							Kernel.exit
						end
					end
					
					# Call main method as long as $scene is effective
					$log.log(false, :info, "started to loop $scene", "Main", "main")
					while $scene != nil
						# Scene-Wechsel aufzeichnen
						$log.log(false, :info, "$scene = #{$scene.class.name}", "Main", "main")
						
						$scene_now = $scene.class.name.to_sym unless $scene.is_a? Scenes::Errors::Error
						
						$scene.main
					end
					$log.log(false, :info, "$scene = nil", "Main", "main")
					# Fade out
					Graphics.transition(20)
				rescue Errno::ENOENT
					# Supplement Errno::ENOENT exception
					# If unable to open file, display message and end
					filename = $!.message.sub("No such file or directory - ", "")
					
					$log.log(true, :warning, "Unable to find file #{filename}.")
				rescue Hangup
					$log.log_else
					Excp_Handle.Hangup($!)
				rescue SyntaxError
					$log.log_else
					Excp_Handle.SyntaxError($!)
				rescue
					$log.log_else
					Excp_Handle.Exception($!)
				end
			
			end
			# Stream schließen
			$log.log(false, :info, "end application and closed stream", "Main", "main")
			$log.close_stream
		end
		
		# Terminates the application
		def self.terminate
			$log.log(false, :info, "Globs: terminate")
			$terminate = true
		end

		# Clears the temporary directory
		def self.clear_temp_directory
			$log.log(false, :info, "Globs: clear_temp_directory")
			files = read_files_recursive("Shared/Temp")
				files.each { |file|
				File.delete("Shared/Temp/" + file)
			}
		end

		# Read a directories input recursively
		def self.read_files_recursive(dir)
			files = []
			Dir.foreach(dir) { |file|
				next if file == "." || file == ".."
				begin
					System::Globs.read_files_recursive(dir + "/" + file) if file.match(/\./).nil?
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

		# Filter the running threads by living and not living threads
		def self.filter_threads
			$log.log(false, :info, "Globs: filter_threads")
			deads = []
			$threads.each { |th|
				deads << th unless th.status == "run"
			}
			deads.each { |th|
				$threads.delete th
			}
		end
		
		# Sets the osu directiory
		def self.set_osu_dir
			Interfacing::TaskHandler.osu_dir
			dir = nil
			while dir.nil?
				dir = Interfacing::NotesHandler.osu_dir?
			end
			$osu_dir = dir
		end
		
	end

end