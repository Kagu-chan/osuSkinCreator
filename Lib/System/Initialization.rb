module System

	module Globs

		module Initialization

			def self.set_variables
				$mouse = Mouse.new
				$threads = []
				$terminate = false
				$frames = 0
				$window_skin = System::Skins::OSC.get_file(:w_skin)
				$force_bg = "Bg"
				$default_bg = System::Skins::OSC.get_file(:d_bg)
				$logo_graph = "Logo"
				$notes = []
				$skin_files = []
				$notes_graph = System::Notes.new
				$first_run = false
				$audio = System::Osc_Audio.new
				$osu_dir = nil
				
				$bg_past = Sprite.new

				$language = ""
				$lang = {}
				$settings = {}

				$log = ExcpLog.new
				$log.open_stream
				$log.log(false, :info, "InitValues: run!")
			end

			def self.ensure_user_dir
				System::Globs.set_user_name
				System::Globs.secure_folder
			end
			
		end

	end

end