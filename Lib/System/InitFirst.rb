module System

	module InitFirst

		def self.init_first
			System::Globs.set_user_name
			System::Globs.secure_folder
		end
		
	end

end

System::InitFirst.init_first