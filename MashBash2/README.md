
# Wor(L)d Swap

A game made using an idea that was thought of a few years prior but created and put into use for the FBLA 2022-2023 game and simulation programming event.



## INSTALLATION AND EXECUTION

You can download it from the itch.io page under the name "WOR(L)D SWAP"

to compile yourself, use default godot export options.

to run the game, just allow executing as program on linux. then run.

to run on windows, run it.

## EDITORS

Made for GODOT 4.0.1 release.

To edit, current version is made for GODOT 4.0.1 full release. feel free to use and edit the game as you see fit.



# Documentation

# Addons
All addons uses were created either in the past or explicitly for this project by (@RogerRandomDev) for the ease of completion of this project.
## Inputs

Addon created to allow the ease of input mapping a controller and mouse to the game itself. created prior to now for previous project that never reached any state good enough to make into a repo. removed most functionality as it was unneeded but converted to allow using the RSTICK for the mouse/cursor location.

## MASHLOG

Addon created for previous FBLA competition game. would store all possible phrases in a single file and call them by an index. it was completely revamped and modified for this project by converting the method to storing everything in an object file for each set of text that can be said. has the option to change the variable speed of text along with the time it will remain visible. has moderate functionality beyond setting text, current face, and current event.

### CREATE DIALOGUE

Dialogue object is used to handle the dialogue. it has 3 variables which are arrays to handle.

	Dialogue:the text which will be spoken in the dialogue box

	curFace: the current face from the character speaking the dialogue

	curAction:the event that takes place when this set of dialogue begins. can be set to nothing.

the curAction stores the dialogueEvent object, which has 2 arrays. one where you set the index for the event, referenced from the dialogue Actions, and a second which stores any type of value, and is the [1]typeof() of the parameter and [2]parameter to be used with the event.

the character speaking is chosen via setting the IconSet, which can be modified via an event.


#### HOW TO ADD CUSTOM/MODIFY EVENTS

The main script for this addon has a collection of variables listed in the top in comments which determine event actions. these can be changed and rebound as you see fit.

The eventActions corrseponds with the event that will be called when that is the value of the action in the event action object. also requires setting of the event default parameter and parameter type to allow ease of use and consistency.

The action that is called is a function, which will call with the parameters provided in the event object for the dialogue. the default functions can be modified, but would not reccomend as it may be game-breaking.

#### DEFAULT EVENTS

	SetCell
	ShakeCamera
	MoveCamera
	ResetCamera
	ChangeSpeaker
	toggleplayerlock
	toggleEditor
	changeScene
	showLogic
	showControls


#### DEFAULT FACES

	Default
	Smile
	Frown
	MadDefault
	MadSmile
	MadFrown
	SquintNeutral
	SquintSmile
	SquintFrown
	GrinSquint
	SquintSmallFrown


#### INVOKING DIALOGUE

The dialogue can be invoked via the function load_dialogue(content,iconset)

the content will be one of the dialogue objects, and the charset will be an iconset object, which stores the textures for all the faces along with the color modulation for the active speaker. the game by default never changes this, but it is there in case it is needed or desired.

To check if dialogue is already being displayed, you can call can_load_dialogue()

this will return if you have any dialogue currently running

SwapIcons() function takes an iconset as a parameter and changes the displayed iconset in the dialogue until it is changed again.

## Word

this is a custom Addon created for the main mechanic of the game, handling the entire system of words, along with the object system of the game as well.

### Functionality

WordSystem.gd stores the main file for the addon, and handles all logic for the main system. the mechanic works by keeping track of the object you have currently chosen to swap with, and will convert it's [Status] into a String to display, along with storing a copy to keep track of itself.

it stores the following values:
	
	swapsLeft: remaining # of words you can remove before you are stopped
	hoveringObjects: objects in range of you interacting with
	allDescriptives: the original Status of the object prior to modification
	hoveringObject: the object that will be interacted with
	storedWords: the words currently in the player's inventory

the WordSwap.gd in WordSwapper sub-folder contains the main functionality for the actual interface itself. it invokes several functions to allow itself it's functionality.

functions of note include:

	buildPhrase():compiles the status into a string to display on it's interface

	updateFromInput():modifies words based on other words put on.
	I.E. putting KEY on a locked door would remove locked and add open

	addWord():adds a word to the object

## Sound

handles most sound interface for the game, including via multiplayer.

it calls playSound to play a random sound and playSong to play a song

to add sounds, put them in the sounds/world folder and songs into the sounds/music folder

## PauseMenu

handles the display of three things including the pause menu. it shows the pausemenu, the logic gate helper, and the control list for the game.

the game calls functions throughout to display more of these via direct calls through the addon.

## transitionScene

handles the transition animation for changing levels

# Entities/objects

the ENTITIES folder includes three sub-folders. the items for the game, i.e. the objects that can be word-swapped, the player, and shader based objects.

## Entities

the entities includes a subfolder for every single object you can word-swap in the game.
these objects are:
Game Objects and Mechanics
This is a list of game objects and mechanics for a game. Each object/mechanic is described with its properties and behaviors.

	Box
			Pushes buttons
			Can be moved
		Heavy:
			Pushes heavy buttons
			Can't be moved
		Reflective:
			Reflects laser beams
		Light:
			Only pushes light buttons
	Door
			Blocks player and objects
		Locked:
			Can't go through
		Open:
			Allows passage
		Broken:
			Allows passage
	Button
			Activates connected objects
		Toggle:
			Stays on until pressed again
		Heavy:
			Only pressable by heavy boxes and the player
	Teleporter
			Teleports player and objects
			Must be active to work
			Must connect to active teleporter
			Must connect to non-broken teleporter
		Active:
			Allows teleportation
		Disabled:
			Will not allow teleportation
		Weak:
			Will break after use
		Broken:
			Will not allow teleportation
	Logic Gate
			Has logic functions
		Turns on when:
			AND: all inputs are on
			NAND: at least 1 input is off
			OR: at least 1 input is on
			NOR: all inputs are off
			XOR: at least 1 but not all inputs are on
			XNOR: all or no inputs are off
	Laser Shooter
			Must be active to emit laser
		Active:
			Emits a laser beam
			Laser beam blocks player and objects
			Does not block drone
		Disabled:
			Emits no laser beam
	Laser Receiver
			Turns on when hit by laser
	Fan
			Pushes player and objects
		Active:
			Pushes player and objects
		Disabled:
			cannot push any objects including players.
		Weak:
			push range is halved.
		Heavy:
			can push heavy boxes.
		Light:
			can only push light objects.
### Player
the player subfolder contains the player and the vaccuum.

## MULTIPLAYER

The multiplayer system works by getting the host's lan IP relative to the router. (I.E. if you aren't on the same network, you can't play together)

this is then displayed by the host, and when put in by the client, should connect the two and start the lan game.

### FAILSAFES

the game will end whenever the host gets disconnected, since they are handling all information in the game itself.

if a client disconnects, it will simply wait for a new client to join, and then provide them the current game state to allow continued play from where you left off.

prioritize host positions for objects over client positions.


## SCORE SYSTEM

score is determined by time spent to complete the game



## Authors

- [@RogerRandomDev](https://github.com/RogerRandomDev/)
- [@B1gChungus](https://github.com/B1gChungus/)


## Sources
*-was modified to a large extent from base

[Glitch shader-@arlez80](https://godotshaders.com/shader/glitch-effect-shader/)

[Title Shader*-@MacNaab](https://godotshaders.com/shader/input-ouput/)

[Level background*-@gerardogc2378](https://godotshaders.com/shader/stars-shader/)

[Retro Gaming font-dafont.com](https://www.dafont.com/retro-gaming.font)





