# Extended Error Logging RMXP V1.0 by Kagurame
# Credits: Kagurame (Idee, Programmierung)
#          Exsharen (Codeausschnitte zu Fehlerdetails, welche zur
#                    orientierung genutzt wurden)

# Definiere hier, auf welche Daten bei Fehlern verwiesen wird.
module Scenes
	module Errors
		class Fail
			
			# Die E-Mail-Adresse, an die sich gewendet werden kann
			def mail_address; "kai.boese@web.de"; end
				
			# Die HTTP-Adresse, die aufgerufen wird, wenn man bei einem Fehler
			# ESC drückt (Kontakt-Möglichkeit)
			def http_address; "http://osu.ppy.sh/u/1998846"; end
			
			# Dein Name  
			def contact_name; "Kagurame"; end
			
		end
	end
end
  
# In Skripten, die mit Scene beginnen (und hier mitgeliefert werden)
# mit Ausnahme von "Scene_Fail" kannst du entsprechende Fehler-Nachrichten
# festlegen. Beachte die Hinweiße an den entsprechenden Stellen.

module Excp
  
  # Bestimmt mit welcher Scene das Spiel startet
  @start_scene = :SetUp
  
  # Sagt aus, ob das Spiel nach einen Fehler neu gestartet werden soll.
  @restart_on_error = false
  
  # Sagt aus, ob bei einem Fehler die selbe Scene neu gestartet werden soll.
  # (Wird Temporär gehandhabt)
  @retry_on_error = false
  
  # Sagt aus, welche Scene nach einem Fehler gestartet wird. Bei nil passiert hier nichts.
  # (Symbol)
  @surrogate_scene = :Welcome
  
  # Fehler-Scene. Wird bei jedem Fehler gestartet. Bei nil passiert hier nichts.
  # (Symbol)
  @error_scene = :Error
  
  # Bei true werden alle Game-Variablen in eine extra Datei geloggt (Vars.log).
  def self.log_variables; false; end
  
  # Gibt an, ob beim Logging Variablen mit dem Wert "0" ignoriert werden.
  def self.ignore_zero_values; false; end
    
  # Bei true werden alle Game-Switches in eine extra Datei geloggt (Switches.log).
  def self.log_switches; false; end
  
end

class ExcpLog
  
  # Trage hier nach vorhandenem Muster Level ein.
  # Level bestimmen die Tragweite der Nachrichten und du kannst später
  # in den Log-Dateien danach filtern.
  # Bei dem Level ":debug" wird nur dann geloggt, wenn man im Test-Modus spielt.
  def set_levels
    @level = [:info, :debug, :error, :warning]
  end
    
end

# Verwendung:

  # Loggen einer Nachricht
  #  put: true / false: Nachricht per PopUp ausgeben?
  #  level: Log Level (Symbol)
  #  message: Die Nachricht
  #  script: Welches Skript ruft die Funktion? (Optional)
  #  method: Zeile oder Methode wo der Aufruf / Fehler herkommt (Optional)
  
  #  $log.log(put, level, message[, script, method])
  
  # Manuelles Loggen aller Game-Variablen
  #  $log.log_variables
  # Ohne Null-Werte:
  #  $log.log_variables(true)
  
  # Manuelles Loggen aller Game-Switches
  #  $log.log_switches
  # Ohne deaktivierte Switches
  #  $log.log_switches(true)
  
  # Manuelles loggen der Variablen-Typen
  #  (Da hier nur der Logging-Algorythmus angestoßen wird, werden eventuell
  #  bestimmte Logs entsprechend den Einstellungen ausgelassen!)
  #  (ignore_zero_values entspricht dann den Einstellungen)
  #  $log.log_else