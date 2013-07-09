module SkinCreate

	module Context
	
		class LoadSkin
			
			def setup
				@backward = false
				
			end
			
			def unload
			
			end
			
			def update
				return SkinCreate::Context::StartUp.new if @backward
				nil
			end
			
			def has_forward
				false
			end
			
			def has_backward
				true
			end
			
			def go_backward
				@backward = true
			end
			
			def text
				"Which skin would you like to load?"
			end
			
			
		end
		
	end
		
end