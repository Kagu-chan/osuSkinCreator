module Scenes

	class Options
		
		def main
			@context_window = Context_Options.new(Window_Context.new)
			@context_window.setup
			
			Graphics.transition
			loop do
				break unless $scene == self
				Input._update
				Graphics.update
				update
			end
			Graphics.freeze
			
			@context_window.unload
		end
		
		def update
			@context_window.update
		end
		
	end
	
end