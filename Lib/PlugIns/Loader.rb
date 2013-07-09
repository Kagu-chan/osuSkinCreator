module PlugIns
	
	class Loader
		
		def self.load_plugins
			plugins = self.get_plugins
			plugins.each { |plugin|
				f_name = $running_from + "/PlugIns/" + plugin
				
				plug = self.load_plugin(plugin)
				next if not plug
				
				$plugins << plug
				
				plug.init
			}
		end
		
		def self.get_plugins
			Dir.entries($running_from + "/PlugIns").select { |f| !f.include?(".") }
		end
		
		def self.load_plugin(plugin)
			f_name = $running_from + "/PlugIns/" + plugin
			
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
			
			return false if not files.size > 3
			
			PlugIn.new(f_name, !FileTest.exist?(f_name + "/ignore"), files)
		end
		
	end
	
	class PlugIn
	
		attr_reader :name
		attr_reader :location
		attr_reader :files
		attr_reader :description
		attr_reader :settings_class_name
		attr_reader :settings_available
		attr_accessor :active
		
		def initialize(dir, activated, ar)
			@active = activated
			@location = dir
			@name = ar[0]
			@settings_class_name = ar[1]
			@description = ar[2]
			@settings_available = false
			
			3.times { ar.delete_at(0) }
			@files = ar
			
			return self
		end
		
		def init
			return unless @active
			
			@files.each { |file|
				f_name = @location + "/" + file
				require(f_name)
			}
			
			return if @settings_class_name == ""
			c_name = "PlugIns::Settings::" + @settings_class_name
			@settings_available = exist_class?(c_name)
			
			@settings_call = Proc.new() { eval(c_name).new(Window_Context.new) }
		rescue
			alert_error($!)
			@active = false
		end
		
		def call_settings
			return nil unless @settings_available
			return @settings_call.call()
		end
		
		def exist_class?(class_name)
			_class = eval(class_name)
			if _class.class == Class
				return _class.superclass == Context_Base
			end
			return false
		rescue NameError
			return false
		end
		
		def alert_error(error)
			text = error.message
			text += "\n\nThis PlugIn (#{@name}) contains some errors, such as the shown."
			text += "\nAt best, you remove the plugin or deactivate it and report this error"
			text += "\nat the plugin creator (pressing CTRL + C, CTRL + V in any textfield)."
			text += "\n\n\n" + ([error.to_s, ''] + $@).join("\n")
			
			print text
		end
		
		private :exist_class?
		private :alert_error
	end
	
end