# Einstellungen des Debug-Skriptes
module Excp
  
  # Getter
  def self.restart_on_error; @restart_on_error; end
  def self.retry_on_error; @retry_on_error; end
  def self.surrogate_scene; @surrogate_scene; end
  def self.error_scene; @error_scene; end
  def self.start_scene; @start_scene; end
    
  # Setter
  def self.restart_on_error=(value)
    @restart_on_error = value
  end
  
  def self.retry_on_error=(value)
    @retry_on_error = value
  end
  
  def self.surrogate_scene=(value)
    return if !value.is_a? Symbol or value == nil
    @surrogate_scene = value
  end
  
  def self.error_scene=(value)
    return if !value.is_a? Symbol or value == nil
    @error_scene = value
  end
end

# Handlet das Vorgehen nach Fehlern
class Excp_Handle
  
  # Scene-Bestimmung
  def Excp_Handle.set_next_scene
    if Excp.retry_on_error
      Excp.retry_on_error = false
      $current_scene = $scene_now
      return
    end
    if Excp.error_scene != nil
      $current_scene = Excp.error_scene
      return
    end
    if Excp.restart_on_error
      $current_scene = Excp.start_scene
      return
    end
    if Excp.surrogate_scene != nil
      $current_scene = Excp.surrogate_scene
      return
    end
    $scene = nil
  end

  # Hendlen des Fehlers
  def Excp_Handle.handle(e)
    # Herausfinden, in welcher Zeile der Fehler aufgetreten ist
    e.backtrace[0].match(/:([0-9]*):/)
    line = $1
    
    # Herausfinden, in welchem Skript der Fehler aufgetreten ist
    e.inspect.match(/\s#<(.*):/)
    come_from = $1
    
    $log.log(false, :error, e.message, come_from, line)
    $log.write_detail(e)
    
    # Weiteren Vorgehen durch Methode bestimmen lassen
    Excp_Handle.set_next_scene
  end
  
  # Handlet Hangup-Fehler
  def Excp_Handle.Hangup(e)
    $old_error_scene = Excp.error_scene
    Excp.error_scene = :Hangup
    
    Excp_Handle.handle(e)
  end
  
  # Handlet Call-Script-Fehler
  def Excp_Handle.CallScriptError(e)
    $old_error_scene = Excp.error_scene
    Excp.error_scene = :CallScriptError
    
    Excp_Handle.handle(e)
  end
  
  # Handlet Syntax-Error
  def Excp_Handle.SyntaxError(e)
    $old_error_scene = Excp.error_scene
    Excp.error_scene = :SyntaxError
    
    Excp_Handle.handle(e)
  end
  
  # Handlet alle anderen Fehler
  def Excp_Handle.Exception(e)
    Excp_Handle.handle(e)
  end
  
end

# Handlet das Logging von Ereignissen
class ExcpLog
  
  # Setzt @stream auf nil (Solange @stream nil ist, ist kein Stream offen)
  def initialize
    @stream = nil
  end
  
  # Setzt die Log-Level und öffnet den Stream
  def open_stream
    # Levels
    set_levels
		
    # Öffnen des Datei-Streams
    @stream = File.open($user_name + "/Log.txt", "w+")
  end
  
  # Schließt den Datei-Stream
  def close_stream
    # Ist Stream ist nil, dann ist kein Stream offen. Abbruch und Ende.
    if @stream == nil
      print "No stream found. Could not close stream!"
      Kernel.exit
    end
    
    # Schließen des Stream
    @stream.close
    @stream = nil
  end
  
  # Loggen einer Nachricht
  #  put: true / false: Nachricht ausgeben?
  #  level: log level (Symbol)
  #  message
  #  script: Welches Skript ruft die Funktion?
  #  method: Zeile oder Methode wo der Aufruf / Fehler herkommt
  def log(put, level, message, script="Debug", method="log")
    # Debug-Nachrichten nur im Debugging schreiben
    return if level == :debug and not $DEBUG
    
    # Ist Stream ist nil, dann ist kein Stream offen. Abbruch und Ende.
    if @stream == nil
      print "No stream found. Could not Log events!"
      Kernel.exit
    end
    # Wenn ein unbekannter Log-Level genutzt wird, wird dies aufgezeichnet
    unless @level.include? level
      lv = :warning
      msg = "undefined log level :#{level.to_s}"
      log lv msg
      level = :info
    end
    # Sicherstellen das gültige Werte weg geschrieben werden.
    script = "Debug" if script == nil
    method = "log" if method == nil
    
    # Erstellen einer formatierten Nachricht.
    text = "[#{level.to_s}] - [#{script.to_s}:#{method.to_s}] === \"#{message.to_s}\"\n"
    
    # Ausgeben einer Nachricht
    print message if put
    
    # Schreiben in den Stream
    @stream.puts text
  end
  
  def write_detail(excp)
    text = ""
    # Zeit
    time = Time.now
    time = time.strftime("%a %d %b %Y, %X")
    
    text.concat "                    Time: #{time}\n"
    # Fehler-Typ
    text.concat "                    Error type: #{excp.class}\n"
    # Klasse
    text.concat "                    Class: #{$scene.class}\n"
    # Nachricht
    text.concat "                    Message: #{excp.message}\n"
    # Wo?
    text.concat "                    at\n"
    for loc in excp.backtrace
      # Sektion
      section = loc[/(?#Section)(\d)*(:)/]
      
      section_err = section[0, section.length - 1]
      script_name = $RGSS_SCRIPTS[section_err.to_i][1]
      
      loc.match(/:([0-9]*):/)
      line = $1
      
      loc.match(/\s(\W(\w)*\W)/)
      method = $1
      
      next if !line =~ /[0-9]/ or line == nil
      
      msg = "                    #{script_name}, line #{line} #{!method ? '' : ', at ' + method}"
      # Write to file
      text.concat "     #{msg}\n"
    end
    text.concat "--------------------\n"
    
    @stream.puts text
  end
  
  def log_else
    log_variables(Excp.ignore_zero_values) if Excp.log_variables
    log_switches(Excp.ignore_zero_values) if Excp.log_switches
  end
  
  # Schreibt alle Game-Variables in eine Datei.
  # ignore_zero_values gibt an, ob 0-Werte ignoriert werden sollen.
  def log_variables(ignore_zero_values=false)
    data = $game_variables
    text = "cant log variables!"
    unless data.nil?
      # Herausfinden, welche Variaben gesetzt sind
      # (Letzte Nicht-Null-Variable finden)
      last_setted = 0
      for i in 0..5000
        last_setted = i unless data[i] == 0
      end
      data = last_setted == 0 ? [] : data[0..last_setted]
      
      # Variablen "zählen" (Wie viele werden verwendet)
      count_data = data - [0]
      variables_used = count_data.size
      
      text = "Variables: Actually are #{variables_used} variable(s) used!\n\n\n\n"
      
      data.each_index { |array_index|
        value = data[array_index]
        next if value == 0 && ignore_zero_values
        id_text = sprintf("%04d", array_index + 1)
        text += "ID #{id_text}:   #{value}\n"
      }
      text += "\n\n\nNo variables with higher indizies setted"
    end
    stream = File.open("Vars.log", "w+")
    stream.puts text
    stream.close
  end
  
  # Schreibt alle Game-Switches in eine Datei
  def log_switches(ignore_zero_values=false)
    data = $game_switches
    text = "cant log switches!"
    unless data.nil?
      # Herausfinden, welche Variablen gesetzt sind
      # (Letzte Nicht-Null-Variable finden)
      last_setted = 0
      for i in 0..5000
        last_setted = i if data[i]
      end
      data = !last_setted ? [] : data[0..last_setted]
      
      # Variablen "zählen" (Wie viele werden verwendet)
      count_data = data - [false]
      variables_used = count_data.size
      
      text = "Switches: Actually are #{variables_used} switches(s) activated!\n\n\n\n"
      
      data.each_index { |array_index|
        value = data[array_index]
        next if !value && ignore_zero_values
        id_text = sprintf("%04d", array_index + 1)
        text += "ID #{id_text}:   #{value}\n"
      }
      text += "\n\n\nNo switches with higher indizies setted"
    end
    stream = File.open("Switches.log", "w+")
    stream.puts text
    stream.close
  end
  
end