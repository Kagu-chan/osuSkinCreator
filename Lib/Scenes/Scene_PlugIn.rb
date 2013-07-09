module Scenes

	class PlugIn
		
		def initialize(plugin)
			@plug = plugin
		end
		
		def main
			@context_window = Object.const_get("PlugIns").const_get("Settings").const_get(@plug.settings_class_name).new(Window_Context.new)
			@context_window.setup(@plug)
			
			Graphics.transition
			loop do
				break unless $scene == self
				Input._update
				Graphics.update
				update
			end
			Graphics.freeze
			
			@context_window.unload
			$c_plug = nil
		end
		
		def update
			@context_window.update
		end
		
	end
	
end