# Overwrite zum Call-Skript sowie Log-Erweiterungen
class Interpreter
  
  # Aktualisiere Scene_Object
  def refresh_scene
    operation = "$scene = Scenes::" + $current_scene.to_s + ".new"
    proc = Proc.new() { eval(operation) }
    
    proc.call
  end
  
  # Schreibt detaillierte Informationen aus dem aktuellen Event
  def write_inp_details(script)
    text = "Interpreter-Details: \n"
    text += "               @map_id => #{@map_id}\n"
    text += "               @event_id => #{@event_id}\n"
    text += "               @index => #{@index}\n"
    text += "               @message_waiting => #{@message_waiting}\n"
    text += "               @move_route_waiting => #{@move_route_waiting}\n"
    text += "               @button_input_variable_id => #{@button_input_variable_id}\n"
    text += "               @wait_count => #{@wait_count}\n"
    text += "               @child_interpreter => #{@child_interpreter}\n"
    text += "               @branch => #{@branch}\n"
    text += "               @list => \n"
    @list.each { |el|
      text += "                  " + el.to_s + "\n"
      element = el.parameters.join ";"
      text += "                    " + element + "\n"
    }
    text += "\n\n"
    text += "               CallScript text: \n\n"
    text += script
    text += "\n\n"
    
    # Self-Switches des aktuellen Events
    keys = [[$game_map.map_id, @event_id, "A"],
           [$game_map.map_id, @event_id, "B"],
           [$game_map.map_id, @event_id, "C"],
           [$game_map.map_id, @event_id, "D"]]
    keys.each { |key|
      text += "Self-Switch '#{key[2]}': #{$game_self_switches[key] ? 'ON' : 'OFF'}\n"
    }
    
    $log.log(false, :error, text, "Interpreter 8", "write_inp_details")
  end
  
  #--------------------------------------------------------------------------
  # * Script
  #--------------------------------------------------------------------------
  def command_355
    # Set first line to script
    script = @list[@index].parameters[0] + "\n"
    # Loop
    loop do
      # If next event command is second line of script or after
      if @list[@index+1].code == 655
        # Add second line or after to script
        script += @list[@index+1].parameters[0] + "\n"
      # If event command is not second line or after
      else
        # Abort loop
        break
      end
      # Advance index
      @index += 1
    end
    # Evaluation und Fehlerhandling
    begin
      result = eval(script)
    rescue SyntaxError
      $log.log_else
      Excp_Handle.SyntaxError($!)
      write_inp_details(script)
      refresh_scene
    rescue Hangup
      $log.log_else
      Excp_Handle.Hangup($!)
      write_inp_details(script)
      refresh_scene
    rescue
      $log.log_else
      Excp_Handle.CallScriptError($!)
      write_inp_details(script)
      refresh_scene
    end
    
    # If return value is false
    if result == false
      # End
      return false
    end
    # Continue
    return true
  end
  
end