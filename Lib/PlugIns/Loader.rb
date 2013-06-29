module PlugIns
	
	class Loader
		
		def self.load_plugins
			plugins = self.get_plugins
			plugins.each { |plugin|
				f_name = $running_from + "/PlugIns/" + plugin
				
				plug = self.load_plugin(plugin)
				next if not plug
				
				$plugins << plug
				
				$desc = nil
				plug.init
			}
		end
		
		def self.get_plugins
			Dir.entries($running_from + "/PlugIns").select { |f| !f.include?(".") }
		end
		
		def self.load_plugin(plugin)
			f_name = $running_from + "/PlugIns/" + plugin
			
			return false if FileTest.exist?(f_name + "/ignore")
			return false if not FileTest.exist?(f_name + "/load.rb")
			
			encode = "files = ["
			ar_end = "]"
			
			file = f_name + "/Load.rb"
			f = File.open(file, "r+")
			inner_ar = f.read
			f.close
			
			code = encode + inner_ar + ar_end
			valid = false
			files = nil
			begin
				(Proc.new() { eval(code) }).call()
				return false if not files.is_a?(Array)
			rescue; return false; end
			
			return false if not files.size > 1
			
			return PlugIn.new(f_name, files)
		end
		
	end
	
	class PlugIn
		
		@@plugins = 0
		
		attr_reader :name
		attr_reader :location
		attr_reader :files
		attr_reader :id
		attr_reader :description
		
		def initialize(dir, ar)
			@location = dir
			@name = ar[0]
			
			ar.delete_at(0)
			@files = ar
			
			return self
		end
	
		def init
			@files.each { |file|
				f_name = @location + "/" + file
				require(f_name)
			}
			
			@description = $desc.nil? ? "A PlugIn named #{@name}" : $desc
		end
	
	end
	
end