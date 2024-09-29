extends Node

var network = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 1909

func _ready():
	ConnectToServer()

func ConnectToServer():
	network.create_client(ip, port)
	multiplayer.set_multiplayer_peer(network)

	multiplayer.connect("connection_failed", _OnConnectionFailed)
	multiplayer.connect("connected_to_server", _OnConnectionSucceded)

func _OnConnectionFailed():
	print("Failed to connect")

func _OnConnectionSucceded():
	print("Succesfully connected")