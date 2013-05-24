# Note: Some code is stored in Game.rxproj => The reason is the encoding of some characters (utf8 / ansi)

module Input

	def self.kb_state
    Win32API.new('user32',"GetKeyboardState", ['p'],'i')
  end
  
  def self.inp_table
    "qwertzuiopü+#asdfghjklöäyxcvbnm,.-^1234567890ß´ backentf"
  end
	
	def self.text_init
    @last ||= 0
    @shift ||= false
    @alt_gr ||= false
    @ctrl ||= false
    @alt ||= false
    @caps ||= false
    @caps_d ||= false
  end
  
  def self.text_input
    @last ||= 0
    @shift ||= false
    @alt_gr ||= false
    @ctrl ||= false
    @alt ||= false
    @caps ||= false
    @caps_d ||= false
    
    inp = _curr_changed?
    return [] if inp.nil? || inp.size == 0
    
    result = []
    inp.each { |e|
      @shift = !@shift if e == "shift"
      @alt_gr = !@alt_gr if e == "alt gr"
      @ctrl = !@ctrl if e == "ctrl"
      @alt = !@alt if e == "alt"
      
      if e == "caps"
        if @caps_d
          @caps = !@caps
          @caps_d = false
        else
          @caps_d = true
        end
      end
      
      if inp_table.include? e
        if @last == e
          result << e
          @last = 0
        else
          @last = e
        end
      end
    }
    
    invert = @shift || @caps
    alter = @alt_gr || (@ctrl && @alt)
    
    result = _alter(result) if alter
    result = _invert(result) if invert && !alter
    
    result
  end

  def self._alter(inp)
    for i in 0...inp.size
      e = inp[i]
      if @altgr_keys.has_key? e
        e = @altgr_keys[e]
      end
      inp[i] = e
    end
    inp
  end
  
  def self._invert(inp)
    for i in 0...inp.size
      e = inp[i]
      if @shift_keys.has_key? e
        e = @shift_keys[e]
      end
      inp[i] = e
    end
    inp
  end
	
  ##############################################################################
  #  Funktionen:
  #     _exist?("name")     => [bool] Existiert die Taste "name"?
  #     _pressed?("name")      => [bool] Wird gedrückt? (auch wenn gehalten)
  #     _trigger?("name")       => [bool] Wurde gerade heruntergedrückt?
  #     _unpress?("name")         => [bool] Wurde gerade losgelassen?
  #     _keyboard_layout     => [array] Stadien aller Tasten
  #     _curr_changed? => [array] Namen aller eben veränderten Tasten
  #     _curr_trigger? => [array] Namen aller eben gedrückten Tasten
  #     right_now_let_keys     => [array] Namen aller eben losgelassenen Tasten
  #     _curr_press?       => [array] Namen aller gedrückten Tasten

  def self._exist?(key)
    return(@keys.has_key?(key))
  end
  
  #-----------------------------------------------------------------------------
  ####Rückgabe    True, wenn die Taste gedrückt ist.
  ####Parameter
  #taste    :Der Name der zu überprüfenden Taste
  #-----------------------------------------------------------------------------
  def self._press?(key)
    return false unless _exist? key
    # Equivalent nur schneller zu: if(@new_keys[@keys[key]] > 1)
    @new_keys[@keys[key]] & 128 == 128
  end
  #-----------------------------------------------------------------------------
  ####Rückgabe    True, wenn die Taste gerade gedrückt wurde.
  ####Parameter
  #taste    :Der Name der zu überprüfenden Taste
  #-----------------------------------------------------------------------------
  def self._trigger?(key)
    return false unless _exist? key
    return false if @old_keys[@keys[key]] == @new_keys[@keys[key]]
    
    @new_keys[@keys[key]] & 128 == 128
  end
	#-----------------------------------------------------------------------------
  ####Rückgabe    True, wenn die Maus (links) gerade gedrückt wurde.
  ####Parameter
  #-----------------------------------------------------------------------------
	def self.mouse?
		_trigger? "l mouse"
	end
  #-----------------------------------------------------------------------------
  ####Rückgabe    True, wenn die Taste gerade losgelassen wurde.
  ####Parameter
  #taste    :Der Name der zu überprüfenden Taste
  #-----------------------------------------------------------------------------
  def self._unpress?(key)
    return false unless _exist? key
    return false if @old_keys[@keys[key]] == @new_keys[@tasten[key]]
    
    @new_keys[@keys[key]] & 128 != 128
  end
  
  #-----------------------------------------------------------------------------
  ####Rückgabe    Alle Tasten-Stadien, hauptsächlich intern benötigt
  #-----------------------------------------------------------------------------
  def self._keyboard_layout()
    a_keys = 0.chr * 256
    kb_state.call(a_keys)
    
    a_keys
  end
  #-----------------------------------------------------------------------------
  ####Rückgabe    True, wenn die Taste gedrückt ist.
  ####Parameter
  #taste    :Der Code der zu überprüfenden Taste
  #-----------------------------------------------------------------------------
  def self._cpress?(code)
    # Equivalent nur schneller zu: if(aKeys[@tasten[taste]] > 1)
    @new_keys[code] & 128 == 128
  end
  
  #-----------------------------------------------------------------------------
  ####Rückgabe    [Array] Gibt Tastennamen der Tasten zurück, die gerade 
  #               geändert wurden.
  #-----------------------------------------------------------------------------
  def self._curr_changed?()
    ret = []
    i = 0
    until @old_keys[i].nil?
      ret << @keys_inverted[i] unless @old_keys[i] == @new_keys[i]
      i += 1
    end
    
    ret
  end
  
  #-----------------------------------------------------------------------------
  ####Rückgabe    [Array] Gibt Tastennamen der Tasten zurück, die gedrückt sind.
  #-----------------------------------------------------------------------------
  def self._curr_press?()
    ret = []
    i = 0
    until @old_keys[i].nil?
      ret << @keys_inverted[i] if @new_keys[i] & 128 == 128
      i += 1
    end
    
    ret
  end
  #-----------------------------------------------------------------------------
  ####Rückgabe    [Array] Gibt Tastennamen der Tasten zurück, die gerade 
  #               gedrückt wurden.
  #-----------------------------------------------------------------------------
  def self._curr_trigger?()
    ret = []
    i = 0
    until @old_keys[i].nil?
      ret << @keys_inverted[i] if @old_keys[i] != @new_keys[i] && (@new_keys[i] & 128 == 128)
      i += 1
    end
    
    ret
  end
  
  def self._update
    @old_keys = @new_keys
    @new_keys = _keyboard_layout
    update
  end
	
end

Input._init
Input.text_init

# Not in file stored code:

=begin

  def self._init()
    
    @keys = {
      #--------------------------Maus
      "l mouse" =>      0x01,   #Linke Maustaste
      "r mouse" =>      0x02,   #Rechte Maustaste
      "m mouse" =>      0x04,   #Mittlere Maustaste
      #--------------------------Special
      "back" =>         0x08,   #Backspace
      "tab" =>          0x09,   #Tabulator-Taste
      "enter" =>        0x0D,   #Enter
      "shift" =>        0x10,   #Eine der Shift-Tasten
      "ctrl" =>         0x11,   #Alt Gr-Taste oder eine der Strg-Tasten
      "alt" =>          0x12,   #Eine alt oder die Num-Block-Taste5 mit num lock
      "caps" =>         0x14,   #capstaste
      "esc" =>          0x1B,   #Escape
      "space" =>        0x20,   #Leertaste
      " " =>            0x20,
      #--------------------------Extra-Block
      "bild oben" =>    0x21,
      "bild unten" =>   0x22,
      "ende" =>         0x23,
      "pos1" =>         0x24,
      #--------------------------Pfeil
      "left" =>         0x25,
      "up" =>           0x26,
      "right" =>        0x27,
      "down" =>         0x28,
      #--------------------------Extra-Block
      "snapshot" =>     0x2C,
      "einfg" =>        0x2D,
      "entf" =>         0x2E,
      #--------------------------Zahlen
      "0" =>            0x30,
      "1" =>            0x31,
      "2" =>            0x32,
      "3" =>            0x33,
      "4" =>            0x34,
      "5" =>            0x35,
      "6" =>            0x36,
      "7" =>            0x37,
      "8" =>            0x38,
      "9" =>            0x39,
      #--------------------------Alphabet
      "a" =>            0x41,
      "b" =>            0x42,
      "c" =>            0x43,
      "d" =>            0x44,
      "e" =>            0x45,
      "f" =>            0x46,
      "g" =>            0x47,
      "h" =>            0x48,
      "i" =>            0x49,
      "j" =>            0x4A,
      "k" =>            0x4B,
      "l" =>            0x4C,
      "m" =>            0x4D,
      "n" =>            0x4E,
      "o" =>            0x4F,
      "p" =>            0x50,
      "q" =>            0x51,
      "r" =>            0x52,
      "s" =>            0x53,
      "t" =>            0x54,
      "u" =>            0x55,
      "v" =>            0x56,
      "w" =>            0x57,
      "x" =>            0x58,
      "y" =>            0x59,
      "z" =>            0x5A,
      #--------------------------Special
      "l windows" =>    0x5B,   #linke "Windows-Taste"
      "r windows" =>    0x5C,   #rechte "Windows-Taste"
      "menue" =>        0x5D,   #rechte "Windows-Taste"
      #--------------------------Num-Block
      "num 0" =>        0x60,
      "num 1" =>        0x61,
      "num 2" =>        0x62,
      "num 3" =>        0x63,
      "num 4" =>        0x64,
      "num 5" =>        0x65,
      "num 6" =>        0x66,
      "num 7" =>        0x67,
      "num 8" =>        0x68,
      "num 9" =>        0x69,
      "num *" =>        0x6A,
      "num +" =>        0x6B,
      "num -" =>        0x6D,
      "num ," =>        0x6E,
      "num /" =>        0x6F,
      #--------------------------F-Zeichen
      "F1" =>           0x70,
      "F2" =>           0x71,
      "F3" =>           0x72,
      "F4" =>           0x73,
      "F5" =>           0x74,
      "F6" =>           0x75,
      "F7" =>           0x76,
      "F8" =>           0x77,
      "F9" =>           0x78,
      "F10" =>          0x79,
      "F11" =>          0x7A,
      "F12" =>          0x7B,
      #--------------------------Num-Block
      "num lock" =>     0x90,
      #--------------------------Extra-Block
      "scroll" =>       0x91,
      #--------------------------Special
      "l shift" =>      0xA0,
      "r shift" =>      0xA1,
      "l strg" =>       0xA2,
      "r strg" =>       0xA3,
      "l alt" =>        0xA4,
      "alt gr" =>       0xA5,
      #--------------------------Sonderzeichen
      "ü" =>            0xBA,
      "+" =>            0xBB,
      "," =>            0xBC,
      "-" =>            0xBD,
      "." =>            0xBE,
      "#" =>            0xBF,
      "ö" =>            0xC0,
      #--------------------------Sonderzeichen
      "ÃŸ" =>            0xDB,
      "^" =>            0xDC,
      "Â´" =>            0xDD,
      "ä" =>            0xDE,
      "<" =>            0xE2}
    @hAlternativKeys = {
      #--------------------------Maus
      "left mouse" =>   0x01,   #Linke Maustaste
      "right mouse" =>  0x02,   #Rechte Maustaste
      "middle mouse" => 0x04,   #Mittlere Maustaste
      #--------------------------Special
      "tabulator" =>    0x09,   #Tabulator-Taste
      "steuerung" =>    0x11,   #Alt Gr-Taste oder eine der Strg-Tasten
      "alternativ" =>   0x12,   #Eine alt oder die Num-Block-Taste5 mit num lock
      "escape" =>       0x1B,   #Escape
      "leertaste" =>    0x20,   #Leertaste
      #--------------------------Pfeil
      "links" =>        0x25,
      "hoch" =>         0x26,
      "oben" =>         0x26,
      "rechts" =>       0x27,
      "unten" =>        0x28,
      #--------------------------Special
      "left windows" => 0x5B,   #linke "Windows-Taste"
      "right windows" =>0x5C,   #rechte "Windows-Taste"
      "menü" =>         0x5D,   #rechte "Windows-Taste"
      #--------------------------Num-Block
      "num" =>          0x90,
      #--------------------------Special
      "left shift" =>   0xA0,
      "right shift" =>  0xA1,
      "left strg" =>    0xA2,
      "right strg" =>   0xA3,
      "left alt" =>     0xA4,
      "alt gr" =>       0xA5}
    
    @shift_keys = {
      "a" => "A",
      "b" => "B",
      "c" => "C",
      "d" => "D",
      "e" => "E",
      "f" => "F",
      "g" => "G",
      "h" => "H",
      "i" => "I",
      "j" => "J",
      "k" => "K",
      "l" => "L",
      "m" => "M",
      "n" => "N",
      "o" => "O",
      "p" => "P",
      "q" => "Q",
      "r" => "R",
      "s" => "S",
      "t" => "T",
      "u" => "U",
      "v" => "V",
      "w" => "W",
      "x" => "X",
      "y" => "Y",
      "z" => "Z",
      "^" => "Â°",
      "1" => "!",
      "2" => "\"",
      "3" => "§",
      "4" => "$",
      "5" => "%",
      "6" => "&",
      "7" => "/",
      "8" => "(",
      "9" => ")",
      "0" => "=",
      "ß" => "?",
      "´" => "`",
      "+" => "*",
      "#" => "'",
      "-" => "_",
      "." => ":",
      "," => ";",
      "<" => ">",
      "ä" => "Ä",
      "ö" => "Ö",
      "ü" => "Ü"}
    
    @altgr_keys = {
      "q" => "@",
      "e" => "€",
      "+" => "~",
      "<" => "|",
      "m" => "µ",
      "2" => "²",
      "3" => "³",
      "7" => "{",
      "8" => "[",
      "9" => "]",
      "0" => "}",
      "ß" => "\\"}
    
    @keys_inverted = @keys.invert # invertiert (tauscht) schlüssel und key
    @keys.update(@hAlternativKeys) # fürht zwei hashes zusammen
    
    _update
  end
	
=end