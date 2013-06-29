module Scenes

	class ReadSkinFiles
		
		def main
			$skin_files = []
			
			$notes << "Checking if analized skin files available..."
			
			System::Threads.update_skin_lib(Interfacing::NotesHandler.skin_available?)
			
			Graphics.transition
			loop do
				break unless $scene == self
				Input._update
				Graphics.update
				update
			end
			Graphics.freeze
			
			$notes.clear
		end
		
		def update
			$scene = Scenes::Welcome.new if $th___update_skin_lib
		end
		
	end
	
end

=begin

rescue
	  error = ([$!.to_s, ''] + $@).join("\n")
	  print error
		
=end