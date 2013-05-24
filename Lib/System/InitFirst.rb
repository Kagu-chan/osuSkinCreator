module InitFirst

	def self.init_first
		Globs.set_user_name
		Globs.secure_folder
	end
	
end

InitFirst.init_first