module Scenes

	class Skins
		
		def main
			
			@current_context = nil
			@window = Window_Context.new
			@next_context = SkinCreate::Context::StartUp.new
			
			@back = Sprite.new; @back.visible = false
			@back.bitmap = Bitmap.new System::Skins::OSC.get_file(:menu_back)
			
			@back.x = 5
			@back.y = 480 - @back.bitmap.height - 5
			@back.add_info_text("Go back to last screen")
			
			@enter = Sprite.new; @enter.visible = false
			@enter.bitmap = Bitmap.new System::Skins::OSC.get_file(:menu_enter)
			
			@enter.x = 640 - @enter.bitmap.width - 5
			@enter.y = 480 - @enter.bitmap.height - 5
			
			Graphics.transition
			loop do
				break unless $scene == self
				Graphics.update
				Input._update
				update
			end
			Graphics.freeze
			
			@enter.dispose
			@back.dispose
			@current_context.unload
			@window.dispose
			@title.dispose
		end
		
		def refresh
			@current_context.unload unless @current_context.nil?
			@current_context = @next_context
			@current_context.setup
			
			unless @title
				@title = Sprite.new
				@title.y = 52
			end
			@title.bitmap.clear unless @title.bitmap.nil?
			
			@title.bitmap = Bitmap.new(640, 26)
			@title.bitmap.draw_text(@title.bitmap.rect, @current_context.text, 1)
			
			@enter.visible = @current_context.has_forward
			@back.visible = @current_context.has_backward
		end
		
		def update
			refresh unless @current_context == @next_context
			
			ret = @current_context.update
			@next_context = ret unless ret.nil?
			
			@current_context.go_forward if @enter.visible && @enter.mouse_over? && Input.mouse?
			@current_context.go_backward if @back.visible && @back.mouse_over? && Input.mouse?
		end
		
	end
	
end