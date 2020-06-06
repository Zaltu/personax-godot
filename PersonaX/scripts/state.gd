extends Node

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
