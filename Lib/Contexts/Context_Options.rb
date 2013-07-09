class Context_Options < Context_Base
	
	def setup
		gr_add Bitmap.new(@contents.w, 32)
    gr_last.bitmap.draw_text(gr_last.bitmap.rect, $lang[:options], 1)
    
    @hovers = []
    
    @hovers << add_rel(34, :r, CheckBox.new($settings[:update_at_startup]), $lang[:update_skinlib])[0]
		@hovers << add_rel(68, :r, Label.new(256, $osu_dir), "Your osu! path:")[0]
		@hovers << add_rel(102, :r, Label.new(256, "#{$plugins.size} plugin(s) installed"), "PlugIns")[0]
		
		@hovers[2].opacity = 120 if $plugins.size == 0
		
		activate_back
	end
  
  def update
		@inp_c = Input.trigger? Input::C
		@inp_esc = Input.trigger? Input::B
		@inp_m = Input.mouse?
		@inp_u = Input.trigger? Input::UP
		@inp_d = Input.trigger? Input::DOWN
		
		@hovers.each_index { |i|
			hover = @hovers[i]
			next if i == 2 && $plugins.size == 0
			hover.bitmap.hover = hover.mouse_over?
		}
    exit if @inp_esc
		
    if @inp_c || @inp_m
			if @hovers[0].bitmap.hover
				save_update_at_startup
			end
			if @hovers[1].bitmap.hover
				system "Explorer \"#{$osu_dir}\""
			end
			if @hovers[2].bitmap.hover && $plugins.size != 0
				$scene = Scenes::PlugIns.new
			end
    end
    
		super
    nil
  end
	
	def exit
		$notes.clear
		$scene = Scenes::Welcome.new
	end
	
	def save_update_at_startup
		@hovers[0].bitmap.checked = !@hovers[0].bitmap.checked
    $settings[:update_at_startup] = @hovers[0].bitmap.checked
    System::Saves.save_settings
	end
	
end