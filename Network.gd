extends Node

var ADRESS = "127.0.0.1"
func get_adress():
	var adress = get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/HBoxContainer/ADRESS").get_text()
	if adress == "":
		adress = ADRESS
	return adress
var PORT = "8910"
func get_port():
	var port = get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/HBoxContainer2/PORT").get_text()
	if port == "":
		port = PORT
	return int(port)

var Map

#### Network callbacks from SceneTree ####

# callback from SceneTree
func _player_connected(_id):
	#someone connected, start the game!
	Map = load("res://Maps/Map.tscn").instance()
	
	get_tree().get_root().add_child(Map)
	get_node('/root/HUD/Menu').hide()
	get_node('/root/HUD/GamePlay').show()

func _player_disconnected(_id):

	if get_tree().is_network_server():
		_end_game("Client disconnected")
	else:
		_end_game("Server disconnected")

# callback from SceneTree, only for clients (not server)
func _connected_ok():
	# will not use this one
	pass
	
# callback from SceneTree, only for clients (not server)	
func _connected_fail():

	_set_status("Couldn't connect",false)
	
	get_tree().set_network_peer(null) #remove peer
	
	get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/HOST").set_disabled(false)
	get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/JOIN").set_disabled(false)

func _server_disconnected():
	_end_game("Server disconnected")
	
##### Game creation functions ######

func _end_game(with_error=""):
	if Map:
		#erase pong scene
		Map.free() # erase immediately, otherwise network might show errors (this is why we connected deferred above)
		get_node('/root/HUD/Menu').show()
		get_node('/root/HUD/GamePlay').hide()
	
	get_tree().set_network_peer(null) #remove peer
	
	get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/HOST").set_disabled(false)
	get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/JOIN").set_disabled(false)
	
	_set_status(with_error, false)

func _set_status(text, isok):
	get_node('/root/HUD/MSG').set_text(text)

func _on_host_pressed():
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = host.create_server(get_port(), 1) # max: 1 peer, since it's a 2 players game
	if err != OK:
		#is another server running?
		_set_status("Can't host, address in use.",false)
		return
		
	get_tree().set_network_peer(host)
	get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/HOST").set_disabled(true)
	get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/JOIN").set_disabled(true)
	_set_status("Waiting for player..", true)
	print('waiting')

func _on_join_pressed():
	var ip = get_adress()
	
	if not ip.is_valid_ip_address():
		_set_status("IP address is invalid", false)
		return
	
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	host.create_client(ip, get_port())
	get_tree().set_network_peer(host)
	
	_set_status("Connecting..", true)
	print('connecting')


### INITIALIZER ####
	
func _ready():
	# connect all the callbacks related to networking
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/HBoxContainer/ADRESS").placeholder_text = ADRESS
	get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/HBoxContainer2/PORT").placeholder_text = PORT
	
	get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/HOST").connect('pressed', self, '_on_host_pressed')
	get_node("/root/HUD/Menu/PanelContainer/VBoxContainer/JOIN").connect('pressed', self, '_on_join_pressed')

