# Glitch Rendering for DragonRuby!

Code to glitch up a sprite using chunks of the original sprite in randomized locations in the sprite area.

![Screenshot of some glitched sprites in action](glitch_screenshot.png?raw=true "What this effect does to our poor little purple dragon")

## Instructions:
To run the demonstration, run the dragonruby.exe file.  Press space bar to see the sprites "glitch up" their rendering.

To use in your own game/app, copy the lib/glitch_rendering.rb file to your own lib folder in your dragonruby project (create it if needed).  Then add 
require 'app/lib/glitch_rendering.rb'
above your tick function.

Now you can call the following commands in your tick function.

## Basic commands

To render a glitched sprite:

sprite_glitch(args, hash_of_sprite, rescramble_delay, divisions_x, divisions_y)

args - the args from your tick, for rendering the sprites to.

hash_of_sprite - a dragonruby hash of a sprite, like {x: 0, y:0, w:32, h:32, path:'sprites/misc/dragon-0.png', angle: 0}

rescramble_delay - a int value for how many frames between each scramble operation to do.

divisions_x, divisions_y - how many sections to cut along each axis to create the glitched images.  (example: a 32x32 with value 4 would make 4 8x8 glitched chunks)

That's really all there is to it.  The demo example simply renders normal sprites when space is NOT pressed, and renders the glitched using the command above if you hold down space. 

The rest of the magic is done in glitch_rendering.rb, look there if you want to modify the sprite output logic.

## Known bugs, missing features

### Rotation Display Error

Rotation of sprites is not supported. The sprite will still chunk but the chunks will not be seamless due to the rotation. This can still be good enough for most glitch uses, but is not "true" to how a real game would have glitched the memory bank.

One possible fix, if you want an alternate look, is to force the angle in glitch_rendering.rb to be set to 0. This will make all the chunks render at 0 rotation, still not ideal but keeps them connected and square.

A better fix would be to come up with some logic to figure out the offsets for placment with the angle taken into account. I am not great with math so haven't figured it out myself yet. You are welcome to try if you wish!

### Timers drain is faster if multiple of the same sprite are rendered

The sprite timers for refresh are stored as a global hash by path name. This works for making multiple sprites that use the same path glitch in sync with each other.

However, a concequence of this is each sprite will count the timers for EACH rendering, instead of for each tick.  So the actual drain will be the total calls to the sprite timer.

This would need a rewrite of the tick calculations so only the first sprite path call would count down.

### Missing feature - Render Target Support

I have not had time to add render target support to the sprite_glitch function.

This kind of rendering creates a LOT of extra sprite count, so it would greatly benefit from putting each glitched sprite into a glitched sprite render_target and only updating the sprite when recalculating the glitch display. If you have performance issues, consider lowering the chunk counts (divisions_x and y), or changing the output to put the sprites into a single render target instead of directly to the sprites array.