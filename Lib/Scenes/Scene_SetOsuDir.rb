module Scenes

	class SetOsuDir
	
		def main
			p "obsolete call!"
			$scene = Scenes::Options.new
			return
			@window = Window_Context.new
			
			@back = Sprite.new
			@back.bitmap = Bitmap.new System::Skins::OSC.get_file(:menu_back)
			
			@back.x = 5
			@back.y = 480 - @back.bitmap.height - 5
			
			@enter = Sprite.new
			@enter.bitmap = Bitmap.new System::Skins::OSC.get_file(:menu_enter)
			
			@enter.x = 640 - @enter.bitmap.width - 5
			@enter.y = 480 - @enter.bitmap.height - 5
			
			@browser = Sprite.new
			@browser.y = 44
			@browser.bitmap = Browse.new(640, 300, "Select your osu! directory", true)
			@browser.bitmap.y = 44
			
			Graphics.transition
			loop do
				break unless $scene == self
				Graphics.update
				Input._update
				update
			end
			Graphics.freeze
			
			dispose
		end
		
		def dispose
			@back.bitmap.dispose
			@back.dispose
			
			@enter.bitmap.dispose
			@enter.dispose
			
			@browser.bitmap.dispose
			@window.dispose
		end
		
		def update
			@browser.bitmap.update
			
			p = Input.mouse?
			if (@back.mouse_over? && p) || (@enter.mouse_over? && p)
				path = @browser.bitmap.path.to_s
				$scene = Scenes::Options.new if try_to_save(path)
			end
		end
		
		def try_to_save(path)
			curr = true
			
			path = path.ensure_extend("/", "\\", "/")
			
			curr = FileTest.exist? path
			curr = FileTest.exist? path + "Songs/" if curr
			curr = FileTest.exist? path + "Skins/" if curr
			
			unless curr
				path = path.ensure_extend("osu!/", "osu!", "osu!/")
				curr = FileTest.exist? path
				curr = FileTest.exist? path + "Songs/" if curr
				curr = FileTest.exist? path + "Skins/" if curr
			end
			
			if curr
				$settings[:osu_dir] = path
				System::Saves.save_settings
			else
				$notes << "In the given directory osu! is no osu! installation!"
			end
			
			curr
		end
		
	end
	
end