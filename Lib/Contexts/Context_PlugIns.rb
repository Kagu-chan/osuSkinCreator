class Context_PlugIns < Context_Base
	
	def setup
		gr_add Bitmap.new(@contents.w, 32)
    gr_last.bitmap.draw_text(gr_last.bitmap.rect, "Installed PlugIns", 1)
		
		@hovers = []
		@options = []
		
		$plugins.each_index { |i|
			plug = $plugins[i]
			element = add_rel((i+1)*34, :r, UpDown.new(128, ["Active", "Inactive"]), plug.name)[0]
			element.bitmap.index = plug.active ? 0 : 1
			@hovers << element
			
			gr_last.add_info_text(plug.description)
			
			gr_add Label.new(128, plug.settings_available ? "Settings" : "No Settings")
			gr_last.x += 460
			gr_last.y += (i+1)*34
			gr_last.opacity = plug.settings_available ? 255 : 120
			@options << gr_last
		}
		
		activate_back
		
		@reset = false
	end
  
  def update
		@inp_c = Input.trigger? Input::C
		@inp_esc = Input.trigger? Input::B
		@inp_m = Input.mouse?
		@inp_u = Input.trigger? Input::UP
		@inp_d = Input.trigger? Input::DOWN
		
		@hovers.each { |hover|
			hover.bitmap.hover = hover.mouse_over?
			hover.update
		}
		@options.each { |hover|
			hover.bitmap.hover = hover.mouse_over?
		}
		exit if @inp_esc
		
		if @inp_c || @inp_m
			@hovers.each_index { |i|
				activator_click(i) if @hovers[i].bitmap.hover
				settings_click(i) if @options[i].bitmap.hover
			}
		end
		
		super
    nil
  end
	
	def activator_click(i)
		plug = $plugins[i]
		loc = plug.location + "/ignore"
		
		if plug.active
			s = File.open(loc, "w+")
			s.puts("")
			s.close
			@hovers[i].bitmap.index = 1
		else
			File.delete(loc)
			@hovers[i].bitmap.index = 0
		end
		
		$notes << "OSC will shutdown when going out of this view."
		@reset = true
		plug.active = !plug.active
	end
	
	def settings_click(i)
		plug = $plugins[i]
		
		if plug.settings_available
			$scene = @reset ? nil : Scenes::PlugIn.new(plug)
		end
	end
	
	def exit
		$notes.clear
		$scene = @reset ? nil : Scenes::Options.new
	end
	
end