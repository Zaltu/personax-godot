# Overview
This is the (currently undocumented) Godot implementation of PersonaX.

Seems much better than Unreal at this point tbqhwys. We'll see how things go and if it can be done.


## Filesystem Organization
For an understandable, simple and representative way or organizing the game resources, I follow this particular structure:  
```
res://
    | project.godot
    |---> envs/
        |
        |---> <envname>/
            |
            | <envname>.tscn
            |---> scripts/
            |   | *.gd
            |
            |---> assets/
                |
                |---> 2d/
                |   | <2dresource>
                |---> 3d/
                    | <3dresource>
    |---> assets/
        |
        |---> 2d/
            | <2dresources>
        |---> 3d/
            | <3dresources>
    |---> ui/
        |
        |---> <uiscenes>
```
This is to separate envs as per the logical separation made by [the model](https://github.com/zaltu/personax-lua-src) and the assets as those exclusive the the envs (and thus not configurable by the model) and generic assets to be loaded into any scene.

UI scenes are meant to be overlayable onto any active spatial scene. The exception in logical terms is `ui/mainmenu`, which doesn't have a better home.