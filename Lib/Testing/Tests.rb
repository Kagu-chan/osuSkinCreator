=begin
class Scene_Title
  
  def update
    if Input.trigger? Input::C
      add_thread(Thread.new(1) { print "ente" })
    end
  end
  
end

    @fncMessageBox       = Win32API.new(u,"MessageBox",['l','p','p','l'],'i')

  #-----------------------------------------------------------------------------
  #Gibt wie normales PRINT, der Titel lässt sich aber selber bestimmen
  ####Parameter
  #inner    :Inhalt des Fensters
  #title    :Titel des Fensters
  #-----------------------------------------------------------------------------
  def print(inner, title = "")
    @fncMessageBox.call(0,"#{inner}",title,0)
  end




staff Miikku (keyboard)

Temp wird Shared

=end