extends Node

onready var LevelManager: Node = get_tree().get_root().get_node_or_null("Game/LevelManager")

var hasKey = false

#User Config
var userConfig = {
	"lights": true
}

func _ready():
	loadConfig()

#Config Save
func saveConfig():
	var cfgFile = File.new()
	cfgFile.open("user://config.cfg", File.WRITE)
	cfgFile.store_line(to_json(userConfig))
	cfgFile.close()

#Config Load
func loadConfig():
	var cfgFile = File.new()
	if not cfgFile.file_exists("user://config.cfg"):
		saveConfig() #Create default config
		return

	cfgFile.open("user://config.cfg", File.READ)
	var data = parse_json(cfgFile.get_line())
	userConfig.lights = data.lights

#Update Lights
func updateLights():
	for light in get_tree().get_nodes_in_group("light"):
		light.enabled = userConfig.lights

#Toggle Lights
func toggleLights():
	userConfig.lights = !userConfig.lights
	updateLights()
	saveConfig()

