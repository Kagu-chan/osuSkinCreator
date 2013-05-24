$threads = []
$terminate = false
$frames = 0
$notes = []
$skin_files = []
$notes_graph = Notes.new
$time_screen_string = "00:00:00"
$timer = Timer.new
$window_skin = "001-Blue011111"
$force_bg = "Bg"
$default_bg = Skins::OSC.get_file(:d_bg)
$logo_graph = "Logo"
$first_run = false
$audio = Osc_Audio.new

$bg_past = Sprite.new

$language = ""
$lang = {}
$settings = {}

$log = ExcpLog.new
$log.open_stream
$log.log(false, :info, "InitValues: run!")