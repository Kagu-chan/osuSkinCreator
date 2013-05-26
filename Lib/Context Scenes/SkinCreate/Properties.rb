module SCreate

	class Properties < Context_Base
		attr_reader :new_context
		
		def initialize
			super(SCreate::Windows::Properties.new)
		end
		
		def setup
			@new_context == nil
			
			gr_add Bitmap.new(@contents.w, 32)
			gr_last.bitmap.draw_text(gr_last.bitmap.rect, "Set Skin Properties", 1)
			
			@back = Sprite.new
			@back.bitmap = Bitmap.new Skins::OSC.get_file(:menu_back)
			
			@back.x = 5
			@back.y = 480 - @back.bitmap.height - 5
		end
		
		def unload
			@back.bitmap.dispose
			@back.dispose
			super
		end
		
		def refresh
		
		end
		
		def update
			if Input.mouse? && @back.mouse_over?
				print "sure to leave"
				$scene = Scenes::Welcome.new
				return
			end
		end
		
	end
	
end