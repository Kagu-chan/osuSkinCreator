#==============================================================================
# ** Audio
#------------------------------------------------------------------------------
#  This class handles data surrounding the system. Backround music, etc.
#  is managed here as well. Refer to "$audio" for the instance of 
#  this class.
#==============================================================================

module System

	class Osc_Audio
		#--------------------------------------------------------------------------
		# * Play Background Music
		#     bgm : background music to be played
		#--------------------------------------------------------------------------
		def bgm_play(bgm)
			@playing_bgm = bgm
			if bgm != nil and bgm.name != ""
				Audio.bgm_play("Audio/BGM/" + bgm.name, bgm.volume, bgm.pitch)
			else
				Audio.bgm_stop
			end
			Graphics.frame_reset
		end
		#--------------------------------------------------------------------------
		# * Stop Background Music
		#--------------------------------------------------------------------------
		def bgm_stop
			Audio.bgm_stop
		end
		#--------------------------------------------------------------------------
		# * Fade Out Background Music
		#     time : fade-out time (in seconds)
		#--------------------------------------------------------------------------
		def bgm_fade(time)
			@playing_bgm = nil
			Audio.bgm_fade(time * 1000)
		end
		#--------------------------------------------------------------------------
		# * Background Music Memory
		#--------------------------------------------------------------------------
		def bgm_memorize
			@memorized_bgm = @playing_bgm
		end
		#--------------------------------------------------------------------------
		# * Restore Background Music
		#--------------------------------------------------------------------------
		def bgm_restore
			bgm_play(@memorized_bgm)
		end
		#--------------------------------------------------------------------------
		# * Play Background Sound
		#     bgs : background sound to be played
		#--------------------------------------------------------------------------
		def bgs_play(bgs)
			@playing_bgs = bgs
			if bgs != nil and bgs.name != ""
				Audio.bgs_play("Audio/BGS/" + bgs.name, bgs.volume, bgs.pitch)
			else
				Audio.bgs_stop
			end
			Graphics.frame_reset
		end
		#--------------------------------------------------------------------------
		# * Fade Out Background Sound
		#     time : fade-out time (in seconds)
		#--------------------------------------------------------------------------
		def bgs_fade(time)
			@playing_bgs = nil
			Audio.bgs_fade(time * 1000)
		end
		#--------------------------------------------------------------------------
		# * Background Sound Memory
		#--------------------------------------------------------------------------
		def bgs_memorize
			@memorized_bgs = @playing_bgs
		end
		#--------------------------------------------------------------------------
		# * Restore Background Sound
		#--------------------------------------------------------------------------
		def bgs_restore
			bgs_play(@memorized_bgs)
		end
		#--------------------------------------------------------------------------
		# * Play Music Effect
		#     me : music effect to be played
		#--------------------------------------------------------------------------
		def me_play(me)
			if me != nil and me.name != ""
				Audio.me_play("Audio/ME/" + me.name, me.volume, me.pitch)
			else
				Audio.me_stop
			end
			Graphics.frame_reset
		end
		#--------------------------------------------------------------------------
		# * Play Sound Effect
		#     se : sound effect to be played
		#--------------------------------------------------------------------------
		def se_play(se)
			if se != nil and se.name != ""
				Audio.se_play("Audio/SE/" + se.name, se.volume, se.pitch)
			end
		end
		#--------------------------------------------------------------------------
		# * Stop Sound Effect
		#--------------------------------------------------------------------------
		def se_stop
			Audio.se_stop
		end
		#--------------------------------------------------------------------------
		# * Get Playing Background Music
		#--------------------------------------------------------------------------
		def playing_bgm
			return @playing_bgm
		end
		#--------------------------------------------------------------------------
		# * Get Playing Background Sound
		#--------------------------------------------------------------------------
		def playing_bgs
			return @playing_bgs
		end
	end
	
end