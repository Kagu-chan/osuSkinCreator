module Scenes

	class Welcome
		
		def main
			System::Threads.read_skin_cache if $skin_files.size == 0
			
			@bg = Sprite.new
			@bg.bitmap = RPG::Cache.picture $force_bg
			
			@logo = Sprite.new
			@logo.bitmap = RPG::Cache.picture $logo_graph
			
			@elements = []
			@c_rects = []
			btl = 120
			bth = 50
			
			@elements << "New1" << "Scan1" << "Options1" << "Exit1"
			@c_rects << Rect.new(23, 414, btl, bth) << Rect.new(180, 414, btl, bth) << Rect.new(338, 414, btl, bth) << Rect.new(492, 414, btl, bth)
			
			@c_rects[0].add_info_text($infos["i0"], $infos["i1"])
			@c_rects[1].add_info_text($infos["i2"])
			@c_rects[2].add_info_text($infos["i3"])
			@c_rects[3].add_info_text($infos["i4"], $infos["i5"])
			
			@index = 0
			
			@element_graphs = []
			4.times {
				s = Sprite.new
				s.bitmap = Bitmap.new(32, 32)
				@element_graphs << s
			}
			refresh
			
			Graphics.transition
			loop do
				break unless $scene == self
				Graphics.update
				Input._update
				update
			end
			Graphics.freeze
			
			@bg.bitmap.dispose
			@bg.dispose
			
			@logo.bitmap.dispose
			@logo.dispose
			
			@element_graphs.each { |e| e.bitmap.dispose; e.dispose }
			
			@c_rects.each { |r| r.dispose }
		end
		
		def refresh
			@element_graphs.each_index { |i|
				@element_graphs[i].bitmap.clear
				f_name = @elements[i] + (@index == i ? "_Hover" : "")
				
				@element_graphs[i].bitmap = (RPG::Cache.picture f_name).clone
			}
		end
		
		def update
			if Input.mouse? || Input.trigger?(Input::C)
				case @index
				when 0
					$scene = Scenes::Skins.new
				when 1
					$scene = Scenes::ReadSkinFiles.new
				when 2
					$scene = Scenes::Options.new
				when 3
					$scene = nil
				end
			end
			mouse_update
		end
		
		def mouse_update
			@c_rects.each_index { |i|
				if @c_rects[i].mouse_over?
					@index = i
					refresh
				end
			}
		end
		
	end
	
end