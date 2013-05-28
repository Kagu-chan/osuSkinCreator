# This file handles filenames skinnable elements.

module System

	module Skins

		module OSC
		
			# file names and keys
			@keys = {:d_bg => ["D_Bg", "Pictures"],
							 :mouse => ["cursor", "SkinFiles"],
							 :w_skin => ["w_skin", "Windowskins"],
							 :menu_back => ["menu-back", "SkinFiles"]
							}
			
			# files which be related to osu skins
			@syncs = [:mouse,
								:menu_back]
			
			def self.get_file(id)
				return "" unless @keys.has_key?(id)
				
				f_name = $user_name + "/OSC_Skin/" + @keys[id][0]
				exist = FileTest.exist?(f_name + ".png") || FileTest.exist?(f_name + ".jpg")
				
				std_name = "Graphics/#{@keys[id][1]}/#{@keys[id][0]}"
				std_name += FileTest.exist?(std_name + ".png") ? ".png" : ".jpn"
				
				return exist ? f_name : std_name
			end
			
			def self.synchronice
				@syncs.each { |element|
					System::Skins::Osu.add_default(@keys[element][0])
				}
			end
			
		end
		
		module Osu
		
			@current_skin_files = []
			@skin_props = {}
			
			@skinnable_dir = "#{$user_name}/OSC_Skin/"
			@skin_files_dir = "Graphics/SkinFiles/"
			
			# the file named string from file.
			def self.get_file(f_string)
				f_path = @skinnable_dir + f_string
				
				overwritten = FileTest.exist?(f_path + ".png") || FileTest.exist?(f_path + ".jpg")
				
				skinned = false
				name = nil
				@current_skin_files.each { |file|
					f_name = file.split("/")
					if f_name[f_name.size - 1] == f_string
						name = file
						skinned = true
					end
				}
				
				return name if skinned
				return overwritten ? f_path : (@skin_files_dir + f_string)
			end
			
			# add a filename as default to the skin which youre creting now
			def self.add_default(f_name)
				f_path = @skinnable_dir + f_name
				
				exist = FileTest.exist?(f_path + ".png") || FileTest.exist?(f_path + ".jpg")
				@current_skin_files << f_path if exist
			end
			
			def add_file(f_name)
				@current_skin_files << f_path if FileTest.exist? f_name
			end
			
			def self.set_properties(hash)
				return unless hash.is_a? Hash
				@skin_props = hash
			end
			
			def reset_skin
				@current_skin_files.clear
			end
			
			def self.compile
				print "sort, then copy skin files into a skin folder"
			end
			
		end
		
	end

end