# Setup der Anwendung!
module Scenes

	class SetUp
		
		def main
			$notes_graph.pos = [0, 425]
			
			@bg = Sprite.new
			@bg.bitmap = (RPG::Cache.picture "Initialisation Screen").clone
			
			System::Loads.startup_init
			$notes << $lang[:load_engine]
			
			System::Threads.run_set_up
			
			Graphics.transition
			loop do
				break unless $scene == self
				Input._update
				Graphics.update
				update
			end
			Graphics.freeze
			
			$notes.clear
			$notes_graph.refresh
			
			@bg.bitmap.dispose
			@bg.dispose
		end
		
		def update
			if $th___run_set_up
				if !FileTest.exist?($user_name + "/SkinCache.skd") || $settings[:update_at_startup]
					$scene = Scenes::ReadSkinFiles.new
				else
					$scene = Scenes::Welcome.new
				end
			end
		end
		
	end
	
end