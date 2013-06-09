module SkinCreate

	module Context
	
		class StartUp
		
			def setup
				$notes << "Calculating overview!"
				texts = ["Create a normal osu! skin", "Create a special skin only for beatmaps"]
				
				@type = 0
				
				@skin_type = Sprite.new
				@skin_type.x = 16
				@skin_type.y = 74
				@skin_type.bitmap = UpDown.new(640 - 32, texts)
				
				@skin_list = []
				@loader = Sprite.new
				@new = Sprite.new
				@last = Sprite.new
				
				Dir.foreach($settings[:osu_dir] + "/Skins") { |file|
					next if file == "." || file == ".."
					
					f_name = "#{$settings[:osu_dir]}/Skins/#{file}/"
					next unless FileTest.exist?(f_name + "skin.ini")
					@skin_list << f_name
				}
				
				unless @skin_list.size == 0
					# draw "load skin" button
					skin = @skin_list[rand(@skin_list.size)]
					
					@loader = SkinPreview.new(222, 110, "Load Skin", skin)
				else
					@loader = SkinPreview.new(222, 110, "No Skins :(")
					@loader.disable
				end
				
				@new = SkinPreview.new(16, 110, "New Skin")
				
				p = $settings[:last] == "" ? nil : $settings[:last]
				t = p.nil? ? "No Skin :(" : "Last Skin"
				@last = SkinPreview.new(428, 110, t, p)
				@last.disable if p.nil?
			end
			
			def unload
				@loader.dispose
				@new.dispose
				@last.dispose
			end
			
			def update
				@skin_type.bitmap.hover = @skin_type.mouse_over?
				@skin_type.bitmap.update
				
				i = @skin_type.bitmap.index
				if i != @type
					@type = i
					p "kontext anpassen!"
				end
				
				@loader.update
				@new.update
				@last.update
				
				nil
			end
			
			def has_forward
				false
			end
			
			def has_backward
				true
			end
			
			def go_backward
				$scene = Scenes::Welcome.new
			end
			
			def text
				"What would you like to do?"
			end
			
		end
		
	end
	
end