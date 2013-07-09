module SkinCreate

	module Context
	
		class StartUp
		
			def update
				@skin_type.bitmap.hover = @skin_type.mouse_over?
				@skin_type.bitmap.update
				
				i = @skin_type.bitmap.index
				if i != @type
					@type = i
					setup
				end
				
				@loader.update
				@new.update
				@last.update
				
				nil
			end
			
		end
		
	end
	
end