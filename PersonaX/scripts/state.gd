extends Node

const LUA_PERSONAX_PATH = "package.path = package.path..';{0}/model/?.lua'";
const MY_LUA_PATH = "package.path = package.path..';{0}/extlib/lua_path/?.lua'";
const MY_LUA_CPATH = "package.cpath = package.cpath..';{0}/extlib/lua_cpath/?.dll'";
const GLOBAL_DATAPATH = "_G.DATAPATH = '{0}/model/data/'";

#K:/Git/personax-lua-src
onready var LOCAL_MODEL_PATH = "K:/Git/personax-lua-src"#OS.get_executable_path().get_base_dir().replace("\\", "/")

var state
var update
var context


func set_context(_update):
	# Split into separate function for better error handling (TODO)
	update = _update
	context = _update.get("key", "unknown").split(".")[0]
	inputhandler.set_active(context)


func sendStateEvent(event):
	var _update = JSON.parse(state.sendStateEvent(JSON.print(event))).result
	set_context(_update)
	return _update


func getUpdate():
	var _update = JSON.parse(state.getUpdate()).result
	set_context(_update)
	return _update


func init():
	if not state:
		state = PXLua.new()
		state.setupLuaState(
			LUA_PERSONAX_PATH.format([LOCAL_MODEL_PATH]),
			MY_LUA_PATH.format([LOCAL_MODEL_PATH]),
			MY_LUA_CPATH.format([LOCAL_MODEL_PATH]),
			GLOBAL_DATAPATH.format([LOCAL_MODEL_PATH])
		)
		print("Godot State Initialized\n", state)
	else:
		print("State already initialized.")


# Singleton utility to apply the setup to the game.
# i.e. start the game, which means calling
# `require("util/state/start_game")`
# NOT USED FOR LOADING. Calling will essentially reset
# the game state to day 1/default start.
# require("util/state/start_game")
func start():
	# Return something?
	# TODO THIS NEEDS TO BE A DOFILE OR THE STATE NEEDS TO BE WIPE-ABLE
	state.startGame()


func load_state():
	pass


func save_state():
	pass


func _exit():
	# Clear lua stack?
	pass
