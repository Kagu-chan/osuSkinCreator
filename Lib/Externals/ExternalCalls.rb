# This file handles runs from external applications

module External

	module Threads
		
		def self.run_skin_reader
			$log.log(false, :info, "External::Threads: run_skin_reader")
			$threads << Thread.new(101) {
				begin
					$notes << "Begin to scan skins"
					cmd = "start " + "Lib\\Externals\\OsuSkinReader.exe \"" + $settings[:osu_dir] + "\" SkinData " + $user_name
					system cmd
				rescue => e
					Thread.main.raise e
				end
			}
		end
		
	end
	
end