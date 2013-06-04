def load_components
	files = [
		# Loading code from System Section
		"\\System/",
		"Extensions",
		"Globs",
		"Audio",
		"Overwrites",
		"Loads",
		"Saves",
		"Notes",
		"Skinnables",
		"Input",
		"MouseController",
		"Initialization",
		"ThreadPointer",
		"Threads",
		
		# Loading Bitmap Extensions
		"\\Bitmap Extensions/",
		"Circle",
		"CheckBox",
		
		# Loading Fields
		"\\Fields/",
		"TextInput",
		
		# Loading Windows
		"\\Windows/",
		"Window_Base",
		"Window_MenuBar",
		"Window_LeftSec",
		"Window_MusicBox",
		"Window_Context",
		"Window_None",
		"Window_Skins",
		
		"\\Windows/SkinCreate/",
		"Window_Properties",
		
		# Loading Scenes
		"\\Scenes/",
		"Scene_Welcome",
		"Scene_ChangeLanguage",
		"Scene_Options",
		"Scene_ReadSkinFiles",
		"Scene_Setup",
		"Scene_Skins",
		"Scene_SkinCreate",
		
		# Loading context sensitive scenes
		"\\Contexts/",
		"Context_Base",
		"Context_Options",
		"Context_Skins",
		"Context_SkinCreate",
		
		"\\Contexts/SkinCreate/",
		"Context_Properties",
		
		# Loading Externals
		"\\Externals/",
		"ExternalCalls",
		
		# Loading some test code files
		"\\Testing/",
		"Tests",
		"TestEngine",
		
		# Loading Exceptions and Exception Handling
		"\\Exceptions/",
		"Exceptions",
		"Settings",
		"Scene_Fail",
		"Error_Scenes",
		"Excp_Log",
		"Interpreter8",
		"GameArrayMockups"
	]
	
	# Catch the running application path
	running_from = File.expand_path(File.dirname(__FILE__))
	
	base_dir = ""
	# Load each named file
	files.each { |file|
		# Build full file name
		if file =~ /^\\/
			base_dir = file 
			next
		end
		
		f_name = running_from + "/Lib" + base_dir + file + ".rb"
		
		# Require and load the current named file
		require(f_name)
	}
end