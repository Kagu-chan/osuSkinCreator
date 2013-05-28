# This file contains functions to load stuff from files

module System

	module Loads
		
		def self.startup_init
			file = File.open($user_name + "/startup.ini", "rb")
			input = file.read
			file.close
			
			inp = input.split("\r\n")
			inp = ["", ""] if inp.size == 0
		
			$language = inp[0] == "" ? "" : "." + inp[0]

			langfile = "Shared/Language/startup" + $language + ".lang"
			
			langfile = "Shared/Language/startup.lang" if !FileTest.exist?(langfile)
			file = File.open(langfile, "rb")
			input = file.read
			file.close
			
			inp = input.split("\r\n")
			
			$lang[:init_oskc] = inp[0]
			$lang[:load_engine] = inp[1]
		end
		
		def self.load_language_file
			$language = "" if !FileTest.exist?("Shared/Language/lang#{$language}.lang")
			file = File.open("Shared/Language/lang#{$language}.lang", "rb")
			input = file.read
			file.close
			
			inp = input.split("\r\n")
			
			$lang[:load_and_sort]           = inp[0]
			$lang[:files_found]             = inp[1]
			$lang[:caching]                 = inp[2]
			$lang[:ready]                   = inp[3]
			$lang[:no_skin_lib]             = inp[4]
			$lang[:skin_lib_loaded]         = inp[5]
			$lang[:load_file_list]          = inp[6]
			$lang[:load_lang]               = inp[7]
			$lang[:new_skin]                = inp[8]
			$lang[:load_skin]               = inp[9]
			$lang[:options]                 = inp[10]
			$lang[:about]                   = inp[11]
			$lang[:update_skinlib]          = inp[12]
			$lang[:force_lib_update]        = inp[13]
			$lang[:task_take_time]          = inp[14]
			$lang[:first_run]               = inp[15]
		end
		
		def self.load_settings
			return if !FileTest.exist?($user_name + "/usersettings.ini")
			file = File.open($user_name + "/usersettings.ini", "rb")
			input = file.read
			file.close
			
			inp = input.split("\r\n")
			inp = ["", "1"] if inp.size == 0
			
			$settings[:osu_dir]           = inp[0]
			$settings[:update_at_startup] = inp[1] == "1" ? true : false
		end
		
		def self.load_file_list
			$notes << $lang[:caching]
			
			file = File.open($user_name + "/SkinCache.skd", "rb")
			list = file.read
			file.close
			
			$skin_files = list.split("\r\n")
			$notes.clear
		end
		
	end

end