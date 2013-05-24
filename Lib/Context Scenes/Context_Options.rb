class Context_Options < Context_Base
	
	def setup
		gr_add Bitmap.new(@contents.w, 32)
    gr_last.bitmap.draw_text(gr_last.bitmap.rect, $lang[:options], 1)
    
    @hovers = []
    
    @hovers << add_rel(34, :r, CheckBox.new($settings[:update_at_startup]), $lang[:update_skinlib])[0]
		@hovers << add_rel(68, :r, TextInput.new(256, $settings[:osu_dir]), "Your osu! path:")[0]
		
		@index = 0
		refresh
	end
  
  def refresh
    @hovers.each_index { |id| @hovers[id].bitmap.hover = id == @index }
    @hovers[1].bitmap.refresh
  end
  
  def update
		update_mouse
    if Input.trigger? Input::B
			$notes.clear
			$scene = Scenes::Welcome.new if try_to_save
    end
    if Input.trigger? Input::DOWN
      @index = (@index + 1) % @hovers.size
      refresh
    end
    if Input.trigger? Input::UP
      @index = (@index - 1) % @hovers.size
      refresh
    end
    if Input.trigger? Input::C
      case @index
      when 0
        save_update_at_startup
			when 1
				try_to_save
      end
    end
    @hovers[@index].bitmap.update if @index == 1
    
    nil
  end
	
	def update_mouse
		@hovers.each_index { |i|
			if @hovers[i].mouse_over? && Input.mouse?
				@index = i
				
				save_update_at_startup if i == 0
				refresh
			end
		}
	end
	
	def save_update_at_startup
		@hovers[@index].bitmap.checked = !@hovers[@index].bitmap.checked
    $settings[:update_at_startup] = @hovers[@index].bitmap.checked
    Save.save_settings
	end
	
	def try_to_save
		curr = true
		
		path = @hovers[1].bitmap.text
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
			Save.save_settings
		else
			$notes << "In the given directory osu! is no osu! installation!"
			@hovers[1].bitmap.text = $settings[:osu_dir]
		end
		
		curr
	end
  
end