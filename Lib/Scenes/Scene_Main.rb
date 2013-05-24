module Scenes

	class Main
		
		def main
			
			@menu_bar       = Window_MenuBar.new
			@left_selection = Window_LeftSec.new
			@music_box      = Window_MusicBox.new
			#@context_window = Window_Context.new
			
			@windows = [@menu_bar, @left_selection, @music_box]
			
			@context_window = Context_Welcome.new(Window_Context.new)
			@context_window.setup
			
			Graphics.transition
			loop do
				break unless $scene == self
				Graphics.update
				Input._update
				update
			end
			Graphics.freeze
			
			@windows.each { |win| win.dispose }
		end
		
		def update
			@windows.each { |win| win.update }
			
			buffer = @context_window.update
			change_context(buffer) unless buffer.nil?
			
			if Input.trigger? Input::B
				arr = []
				$threads.each { |th|
					arr << th.status
				}
				p arr
			end
		end
		
		def change_context(new_context)
			return unless new_context.is_a? Context_Base
			
			@context_window.unload
			@context_window = new_context
			@context_window.setup
		end
		
	end
	
end