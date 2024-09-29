extends CanvasLayer

@onready var shortcuts_path:String = 'SkillBar/Background/MarginContainer/HBoxContainer/'

var loaded_skills:Dictionary = {"Shortcut1": "Ice_Ball", "Shortcut2": "Ice_Spear", "Shortcut3": "Cryo_Bomb"}

func _ready() -> void:
	LoadShortcuts()
	for shortcut in get_tree().get_nodes_in_group('Shortcuts'):
		# CONECTO LA SEÑAL PRESSED DEL BASEBUTTON A MI FUNCION QUE BUSCA RECIBIR EL NOMBRE DEL PADRE DEL SHORTCUT COMO PARAMETRO
		shortcut.pressed.connect(SelectShortcut.bind(shortcut.get_parent().get_name()))

func LoadShortcuts():
	for shortcut in loaded_skills.keys():
		var skill_icon:Texture2D = load("res://Assets/Skills/" + loaded_skills[shortcut] + "_icon.png")
		get_node(shortcuts_path + shortcut + "/TextureButton").set_texture_normal(skill_icon)

func SelectShortcut(shortcut):
	var skill_icon:Texture2D = load("res://Assets/Skills/" + loaded_skills[shortcut] + "_icon.png")
	get_node(shortcuts_path + "/SelectedSkill/TextureRect").set_texture(skill_icon)
	get_parent().get_node("Player").selected_skill = loaded_skills[shortcut]
	
