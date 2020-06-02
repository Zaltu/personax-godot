# Overview
The process to import 3D models is quite simple, albeit it relies on multiple steps that span accross many DCCs, making it hard to remember. This file serves as documentation on the steps required to import 3D models from various sources into Godot properly.

# Importing Persona 3/4 RMD Files
There are a lot of reasonably low-res models already available to be ripped from Persona 3/4. To do so, you will need the following:
- Persona 3/4 ISO
- DkZStudio_0.92B_English
- 3DS Max
- RMD_Maxscript_V4
- Blender 2.81

## TL;DR
Cause I know I'm lazy
- Get RMD file
- Import into Max w/ script
- Export to FBX
- Import to Blender
- Fix materials and looping animations
- Export to glTF 2.0
- Import to Godot

### Getting the source
- First, open DkZStudio. It may give you a runtime error on windows 10, but simply clicking OK should let you continue without issue.
- Open your Persona 3/4 ISO using DkZStudio
- Locate and extract BTL.CVM
- Open BTL.CVM using DkZStudio
- It's very simple to navigate. Find and extract individual files you want, or just dump everything by accident like I did
As the end of this step you should have multiple .RMD files. These are the 3D model and animation files.

### Loading the Source Into Modern Technology
Persona 3 came out like a long time ago. Luckily, some madlad made a Maxscript that extracts the model and animation data and formats it to current standards for 3DS Max. We use this to load the models and animations.
- Open 3DS Max
- From the "Scripting" menu, select "Run Script"
- Select RMD_ModelImport_V4 from wherever you save RMD_Maxscript_V4 to
- This will open another browser for you to select the RMD file you wish to import. Might take a little while as it's reconstructed
- Again, select "Run Script" from the "Scripting" menu, and choose RMD_AnimationImport_V1
- Animations are stored in the same RMD file as the model, just reselect the same one
- 3DS Max only supports one animation timeline, so you will need to choose between any available animations
    - __TODO__ Figure out how to import multiple animations, since I know both Blender and Godot support it
- Once everything is imported, it's time to export that out of 3DS Max
- Go to `File > Export > Export` and save an FBX file wherever you want

### Cleaning for import in Blender
Godot and Blender, both being opensource, have better connectivity than other DCCs. Since it's free, there's no reason to try and match all these steps in 3DS Max.
- Make sure to delete the default Lamp, camera and cube btw ;)
- In Blender, go to `File > Import > FBX` and import the FBX you saved in 3DS Max
- It's likely the model will not be upright. Go ahead and transform it so it's standing or in whatever orientation you want
- In the same vein, match the scale of the object to the project you're working on
- For some reason, most of the materials imported by the maxscript have altered Metallic and Roughness values. This results in some very ugly shading in Godot, so make sure to set all the __Metallic values to 0__, and all the __Roughness values to 1__. This will save time from having to edit them in Godot directly.
- All the distributed models have very numerical IDs associated to them. You can rename meshes and animations here so they make more sense for your project
- For any animation that should be played looping, make sure to append `-loop` to the name! Otherwise it will not loop automatically in Godot and you will have to code (god forbid).
- Once you're ready, select `File > Export > glTF 2.0` and export a glTF format file. Default params should be fine.

### Import to Godot
This is the easy part.
- Drag and drop the glTF file from a file browser into Godot and voila. You're good to go.


# Importing Persona 5 Files
__TODO__