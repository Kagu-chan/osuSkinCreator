module Interfacing

	module TaskHandler
		
		def self.create(file, inp=nil)
			f = File.open("Tasks/" + file, "w+")
			unless inp.nil?
				f.puts inp
			end
			f.puts "\n"
			f.close
		end
		
		def self.analize
			create(Interfacing::Names.tasks[:r_skins])
		end
		
		def self.copy(user_folder)
			create(Interfacing::Names.tasks[:c_skins], user_folder)
		end
		
		def self.create_userFolder(name)
			create(Interfacing::Names.tasks[:c_u_dir], name)
		end
		
		def self.osu_dir
			create(Interfacing::Names.tasks[:gto_dir])
		end
		
	end
	
	module NotesHandler
		
		def self.check_and_get(file)
			f_name = $running_from + "/Messages/" + file
			return nil unless FileTest.exist?(f_name)
			output = []
			f = File.open(f_name, "rb") 
			output = f.read.split("\r\n")
			f.close
			File.delete(f_name)
			output
		end
		
		def self.check(file)
			f_name = $running_from + "/Messages/" + file
			if FileTest.exist? (f_name)
				File.delete(f_name)
				return true
			end
			false
		end
		
		def self.skin_available?
			check(Interfacing::Names.notes[:s_av])
		end
		
		def self.osu_dir?
			out = check_and_get(Interfacing::Names.notes[:odir])
			return out.nil? ? nil : out[0]
		end
		
		def self.udir_created?
			check(Interfacing::Names.notes[:c_uf])
		end
		
		def self.data_copied?
			check(Interfacing::Names.notes[:cskd])
		end
		
		def self.stub_running?
			check(Interfacing::Names.notes[:s_rn])
		end
		
	end
	
end