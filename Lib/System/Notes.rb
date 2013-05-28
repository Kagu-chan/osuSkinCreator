module System

	class Notes
		
		attr_accessor :span, :pos, :size
		
		def initialize
			refresh
			
			@note = Sprite.new; @note.z = 99999
			@note.bitmap = Bitmap.new(1, 1)
			@last_size = 0
			@disposed = false
			@redraw = false
		end
		
		def refresh
			@span = 5
			@size = [640, 24]
			@pos = [0, 0]
		end
		
		def redraw
			@redraw = true
		end
		
		def clear
			$notes = []
		end
		
		def update
			$frames += 1
			
			return if @disposed
			return if $notes.nil?
			return if @last_size == $notes.size && !@redraw
			
			@redraw = false
			@last_size = $notes.size
			
			text = $notes.size > 0 ? $notes[$notes.size - 1] : nil
			
			text = text.to_s
			
			@note.bitmap.clear
			return if $notes.size == 0
			
			@note.x, @note.y = @pos[0], @pos[1]
			begin
				@note.bitmap = Bitmap.new(@size[0], @size[1])
				@note.bitmap.draw_text(@note.bitmap.rect, text, 1)
			rescue
				$log.log(false, :warning, "failed to draw notes: " + text)
			end
		end
		
		def dispose
			@disposed = true
			@note.bitmap.dispose
			@note.dispose
		end
		
	end

end