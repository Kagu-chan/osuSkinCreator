# Diese Klasse stellt den allgemeinen Fehlerbildschirm dar (Basis-Klasse)
module Scenes

	module Errors
	
		class Fail
			
			def message
				# Bitte nicht mehr als 14 Zeilen (Array-Elemente) nutzen
				# Platzhalter: @contact_name wird durch den Kontak-Namen ersetzt
				#              @mail_address wird durch die Mail-Adresse ersetzt
				return [""]
			end
			
			def after_stuff
				nil
			end
				
			def main
				draw
				
				Graphics.transition
				loop do
					break unless $scene == self
					Graphics.update
					Input._update
					update
				end
				Graphics.freeze
				
				dispose
				
				set_scene
				
				after_stuff
			end
			
			def draw
				@bg = Sprite.new
				@bg.bitmap = Bitmap.new(640, 480)
				@bg.bitmap.fill_rect(@bg.bitmap.rect, Color.new(0, 0, 0))
				@texts = []
				message.each_index { |id|
					text = message[id]
					text = text.gsub(/@contact_name/) { contact_name }
					text = text.gsub(/@mail_address/) { mail_address }
					graph = Sprite.new
					graph.x = 0
					graph.y = id * 34
					
					graph.bitmap = Bitmap.new(640, 32)
					graph.bitmap.draw_text(graph.bitmap.rect, text, 1)
					
					@texts.push graph
				}
			end
			
			def dispose
				@bg.bitmap.dispose
				@bg.dispose
				@texts.each { |graph|
					graph.bitmap.dispose
					graph.dispose
				}
			end
			
			def run_link(link)
				 cmd = "start " + link
				 system cmd
			 end 
			
			def update
				if Input.trigger? Input::C
					$scene = nil
					return
				end
				if Input.trigger? Input::B
					run_link http_address
				end
			end
			
			# Scene bestimmen
			def set_scene
				scene = nil
				if Excp.restart_on_error
					scene = Excp.start_scene
				else
					if Excp.surrogate_scene != nil
						scene = Excp.surrogate_scene      
					end
				end
				if scene == nil
					$scene = nil
					return
				end
				operation = "$scene = Scenes::" + scene.to_s + ".new"
				proc = Proc.new() { eval(operation) }
				
				proc.call()
			end
			
		end
		
	end
	
end