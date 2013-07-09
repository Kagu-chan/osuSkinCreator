module SkinCreate

	module Context
	
		class StartUp
		
			def setup(type=0)
				$notes << "Calculating overview!"
				texts = ["Create a normal osu! skin", "Create a special skin only for beatmaps"]
				
				@type = type
				
				@skin_type = Sprite.new
				@skin_type.x = 16
				@skin_type.y = 74
				@skin_type.bitmap = UpDown.new(640 - 32, texts)
				@skin_type.bitmap.index = @type
				
				@skin_list = []
				@new = Sprite.new
				@last = Sprite.new
				
				if @type == 0
					@loader = Sprite.new
					Dir.foreach($osu_dir + "/Skins") { |file|
						next if file == "." || file == ".."
						
						f_name = "#{$osu_dir}/Skins/#{file}/"
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
				end
				
				@new = SkinPreview.new(16, 110, "New Skin")
				
				p = $settings[:last] == "" ? nil : $settings[:last]
				t = p.nil? ? "No Skin :(" : "Last Skin"
				@last = SkinPreview.new(428, 110, t, p)
				@last.disable if p.nil?
				
				$notes.clear
			end
			
			def unload
				@loader.dispose if @type == 0
				@new.dispose
				@last.dispose
				@skin_type.dispose
			end
			
			def update
				@skin_type.bitmap.hover = @skin_type.mouse_over?
				@skin_type.bitmap.update
				
				i = @skin_type.bitmap.index
				if i != @type
					unload
					@type = i
					setup(@type)
				end
				
				@loader.update if @type == 0
				@new.update
				@last.update
				
				ret = nil
				if Input.mouse?
					if @type == 0
						ret = SkinCreate::Context::LoadSkin.new if @loader.hover
					end
				end
				ret
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