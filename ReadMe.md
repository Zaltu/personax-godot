# Overview
This is the (currently undocumented) Godot implementation of PersonaX.

Seems much better than Unreal at this point tbqhwys. We'll see how things go and if it can be done.


## Filesystem Organization
For an understandable, simple and representative way or organizing the game resources, I follow this particular structure:  
```
res://
    | project.godot
    |---> levels/
        |
        |---> <levelname>/
            |
            | <levelname>.tscn
            |---> scripts/
            |   | *.gd
            |
            |---> assets/
                |
                |---> 2d/
                |   | <2dresource>
                |---> 3d/
                    | <3dresource>
```
