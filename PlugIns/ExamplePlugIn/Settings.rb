module PlugIns

	module Settings
	
		class ExampleSettings < Context_Base
		
			def setup(plug)
				@plug = plug
				gr_add Bitmap.new(@contents.w, 32)
				gr_last.bitmap.draw_text(gr_last.bitmap.rect, @plug.name, 1)
				
				@hovers = []
				
				@hovers << add_rel(34, :r, CheckBox.new($plug_example_plugin_show_popup), "Show popup at start")[0]
				
				activate_back
			end
			
			def update
				@inp_c = Input.trigger? Input::C
				@inp_esc = Input.trigger? Input::B
				@inp_m = Input.mouse?
				
				@hovers.each { |hover|
					hover.bitmap.hover = hover.mouse_over?
				}
				exit if @inp_esc
				
				if @inp_c || @inp_m
					if @hovers[0].bitmap.hover
						update_settings
					end
				end
				
				super
				nil
			end
			
			def exit
				$scene = Scenes::PlugIns.new
			end
			
			def update_settings
				plug = @plug
				loc = plug.location + "/show"
				
				if FileTest.exist?(loc)
					File.delete(loc)
					@hovers[0].bitmap.checked = false
				else
					s = File.open(loc, "w+")
					s.puts("")
					s.close
					@hovers[0].bitmap.checked = true
				end
			end
			
		end
		
	end
	
end