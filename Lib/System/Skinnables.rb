# This file handles filenames skinnable elements.

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
				Skins::Osu.add_default(@keys[element])
			}
		end
		
	end
	
	module Osu
	
		@keys = {}
		
		def self.get_file(id)
			# laden der osu datei
		end
		
		def self.add_default(id)
			# hinzufügen von dateien, die im skin ordner abgelegt sind und damit default
		end
		
	end
	
end