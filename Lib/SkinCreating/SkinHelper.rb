module System

	module Skins
	
		module Helper
			
			def self.get_hit_circle(path, number, color=Color.new(0, 0, 0))
				circle_path = calc_path(path, "hitcircle")
				overlay_path = calc_path(path, "hitcircleoverlay")
				default_num_path = calc_path(path, "default-#{number}")
				
				circle = Bitmap.new(circle_path).clone
				overlay = Bitmap.new(overlay_path).clone
				default = Bitmap.new(default_num_path).clone
				
				#circle.coloring(color)
				
				circle.blt(0, 0, overlay, overlay.rect)
				
				c_l = circle.width
				c_h = circle.height
				n_l = default.width
				n_h = default.height
				circle.blt((c_l / 2) - (n_l / 2), (c_h / 2) - (n_h / 2), default, default.rect)
				
				s = Sprite.new
				s.bitmap = circle
				s.zoom_x, s.zoom_y = 0.7, 0.7
				s
			end
			
			def self.get_cursor(path)
				trail_path = calc_path(path, "cursortrail")
				cursor_path = calc_path(path, "cursor")
				
				trail = Bitmap.new(trail_path).clone
				cursor = Bitmap.new(cursor_path).clone
				
				t_size = [trail.width, trail.height]
				c_size = [cursor.width, cursor.height]
				
				under = Bitmap.new([t_size[0], c_size[0]].max, [t_size[1], c_size[1]].max)
				
				m_size = [under.width, under.height]
				
				under.blt((m_size[0] / 2) - (t_size[0] / 2), (m_size[1] / 2) - (t_size[1] / 2), trail, trail.rect)
				under.blt((m_size[0] / 2) - (c_size[0] / 2), (m_size[1] / 2) - (c_size[1] / 2), cursor, cursor.rect)
				
				s = Sprite.new
				s.bitmap = under
				s.zoom_x, s.zoom_y = 0.7, 0.7
				s
			end
			
			def self.get_playfield(path, max_size=[640,480])
				field_path = calc_path(path, "playfield")
				
				field = Bitmap.new(field_path).clone
				
				s = Sprite.new
				s.bitmap = field
				s.scale_down_to(max_size[0], max_size[1])
				s
			end
			
			def self.get_button_with_star(path, max_size=[640,480])
				button_path = calc_path(path, "menu-button-background")
				star_path = calc_path(path, "star")
				
				button = Bitmap.new(button_path).clone
				star = Bitmap.new(star_path).clone
				
				sh = star.height
				sb = button.height
				
				border = (sb - sh) / 2
				button.blt(border, border, star, star.rect)
				
				s = Sprite.new
				s.bitmap = button
				s.scale_down_to(max_size[0], max_size[1])
				s
			end
			
			def self.get_ranking_xh(path)
				rank_path = calc_path(path, "ranking-XH-small")
				
				rank = Bitmap.new(rank_path).clone
				
				s = Sprite.new
				s.bitmap = rank
				#s.zoom_x, s.zoom_y = 0.7, 0.7
				s
			end
			
			def self.calc_path(path, name)
				return System::Skins::Osu.get_file(name) if path == "Graphics/SkinFiles/"
				
				p1 = path + name
				return p1 if FileTest.exist?(p1 + ".png") || FileTest.exist?(p1 + ".jpg")
				p2 = System::Skins::Osu.get_file(name)
				return p2
			end
			
		end
		
	end
	
end