module Scenes
	
	class Welcome
		
		alias_method :old_extendet_main, :main
		
		def main
			load_plugin_settings
		
			text = "This is a message upcoming from the PlugIn 'ExamplePlugIn'.\n"
			text += "Its showing the function of 'aliasing', so methods not must be overwritten. Please dont use \n"
			text += "overwrites in PlugIns, it could get incompatible with other PlugIns or destroy other functions while updates.\n"
			text += "\nTo disable a plugin, go in Options or put a file named 'ignore' into the directory of the plug in. Thank You."
			
			print text if $plug_example_plugin_show_popup
			
			old_extendet_main
		end
		
		def load_plugin_settings
			plug = nil
			$plugins.each { |pl|
				plug = pl if pl.name == "Beispiel-Erweiterung"
			}
			$plug_example_plugin_show_popup = FileTest.exist?(plug.location + "/show")
		end
		
	end
	
end
=begin

Extending Methods:

alias_method :name_of_method_dump, :original_method_name

def original_method_name
	eventually content before original
	
	original_method_name
	
	eventually content after original
end


Extending Classes:

"open" modules and classes, write new methods, ready

class Existing_Class

	def new_method
		content
	end
	
end


Overwrites:

Method-Overwrites are tricky :/
It could be incompatible with other PlugIns, or if i update the system and an existing method, so the overwrite is the old code.
The new code would be overwritten from the old - the overwrite.

So try to dont overwrite existing methods.

If you have to overwrite an existing method, please put the code in to a file named "Overwrites", so each PlugIn writer know
that there are overwrites. If any bug existing with a plugin, so the users could look there. Take care that each overwrite has
the same type of return value as before the overwrite.


Description:

Each PlugIn could have a description.
To add a description, write following in one of the plugin files (not the loadfile!)

$desc = "My description of my awesome plugin."
The value "$desc" if used to read the correct description from file.

=end