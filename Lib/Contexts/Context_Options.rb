class Context_Options < Context_Base
	
	def setup
		gr_add Bitmap.new(@contents.w, 32)
    gr_last.bitmap.draw_text(gr_last.bitmap.rect, $lang[:options], 1)
    
    @hovers = []
    
    @hovers << add_rel(34, :r, CheckBox.new($settings[:update_at_startup]), $lang[:update_skinlib])[0]
		@hovers << add_rel(68, :r, Label.new(256, $osu_dir), "Your osu! path:")[0]
		
		@back = Sprite.new
		@back.bitmap = Bitmap.new System::Skins::OSC.get_file(:menu_back)
		
		@back.x = 5
		@back.y = 480 - @back.bitmap.height - 5
	end
  
	def unload
		@back.bitmap.dispose
		@back.dispose
		super
	end
	
  def update
		@inp_c = Input.trigger? Input::C
		@inp_esc = Input.trigger? Input::B
		@inp_m = Input.mouse?
		@inp_u = Input.trigger? Input::UP
		@inp_d = Input.trigger? Input::DOWN
		
		@hovers.each { |hover|
			hover.bitmap.hover = hover.mouse_over?
		}
    exit if @inp_esc
		
    if @inp_c || @inp_m
			return exit if @back.mouse_over?
			
			if @hovers[0].bitmap.hover
				save_update_at_startup
			end
    end
    
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