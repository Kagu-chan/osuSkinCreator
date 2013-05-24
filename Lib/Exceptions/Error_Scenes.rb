# Die hier enthaltenen Scenes stellen die einzelnen Fehlermeldungen dar.
# Der Text kann jeweils editiert werden, sollte aber nicht mehr als 14 Zeilen
# (Array-Elemente) enthalten.

# Platzhalter: @contact_name wird durch den Kontak-Namen ersetzt
#              @mail_address wird durch die Mail-Adresse ersetzt

# Standard Fehlerbildschirm
module Scenes

	module Errors
	
		class Error < Fail
  
			def message
				["An error occured!",
				 "The error is logged in 'Log.txt'.",
				 "Please send this file to the developers.",
				 "", 
				 "Continue with 'Enter'.", "",
				 "Hit 'Escape' for online help (Profile @contact_name)",
				 "(You have to register!)", "",
				 "E-Mail: @mail_address"]
			end
							
		end
  
# Hangup Exception ("Script is hanging")
		class Hangup < Fail
  
			def message
				["An error occured!",
				 "The error is logged in 'Log.txt'.",
				 "Please send this file to the developers.",
				 "", 
				 "Continue with 'Enter'.", "",
				 "Hit 'Escape' for online help (Profile @contact_name)",
				 "(You have to register!)", "",
				 "E-Mail: @mail_address"]
			end
			
			def after_stuff
				$scene = nil
			end
			
		end

		# Sonstige Fehler in Call-Script
		class CallScriptError < Fail
			
			def message
				["An error occured!",
				 "The error is logged in 'Log.txt'.",
				 "Please send this file to the developers.",
				 "", 
				 "Continue with 'Enter'.", "",
				 "Hit 'Escape' for online help (Profile @contact_name)",
				 "(You have to register!)", "",
				 "E-Mail: @mail_address"]
			end
			
			def after_stuff
				Excp.error_scene = $old_error_scene
			end
			
		end

		# Syntax Exceptions (da Syntax-Error mit ausnahme von 'eval' und Call-Script
		# (ebenfalls 'eval' verwendet) direkt beim Spielstart gemeldet werden (also
		# während der Entwicklung), kann dies verallgemeinert für syntaktische Fehler 
		# in Call-Script-Befehlen gesehen werden)
		class SyntaxError < Fail
			
			def message
				["An error occured!",
				 "The error is logged in 'Log.txt'.",
				 "Please send this file to the developers.",
				 "", 
				 "Continue with 'Enter'.", "",
				 "Hit 'Escape' for online help (Profile @contact_name)",
				 "(You have to register!)", "",
				 "E-Mail: @mail_address"]
			end
			
			def after_stuff
				$scene = nil
			end
			
		end
		
	end
	
end