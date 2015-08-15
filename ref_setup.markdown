---
layout: default
title:  "Reference Setup"
---

Here we go, deep in the belly of the beast! (Well, actually not really, there is C++ code hidden somewhere but unless you curious minds want more, this will stay the realm of yours truly.) Here we will get some insight about the setup file (the .argos one) that defines the experimental conditions. While this might appear as a whole mess at first (it isn't), we won't go too much in details. Only a few key points are of our worries. If you're curious about more, you might want to check the comments in the files provided.

<span id="nbr_robots"/>
##a) Number of robots (or other entity)
There are a few ways to spawn robots in ARGoS. In our case, we used a random spread with the `<distribute>` tag. If you look inside it, you'll see an `<entity>` tag and a `quantity` parameter. As you can already guess, modifying this last one will change the number of robot (or whichever entity).

<span id="new_entities"/>
##b) Adding new entities
As mentioned, a few ways to do so. The most versatile for us will be the distribute one. And easiest will be to actually copy past one of its usage and just modify the entity to fit our needs (mainly a box or a robot, done as shown in the same .argos file).

<span id="arena"/>
##c) Arena size and floor picture
To change the picture on the floor (big up to the [Odyssey](https://en.wikipedia.org/wiki/Magnavox_Odyssey)) you just change the file path of the `path` parameter of the `<floor>` tag.

You will need to adjust the size of the arena accordingly, mainly it having the same ratio of width and height. To do so, you will need to modify the `size` parameter of the `<arena>` tag which takes in order width, height and depth (don't change that last one unless you know what you're doing!).

Last, if you want to have a bounded arena, you will need to change the `size` and `position` of the walls defined as the 4 boxes that follows the `<floor>` tag. 

<span id="debug"/>
##d) Showing rays for debugging purpose
Sometimes you can actually graphically output something relevant about the sensors you're using. Super useful for debugging purpose. In our case, this works for the proximity sensors and for the camera. If you want to see the rays then you just need to search for `showrays` parameter and change its value from "false" to "true". Guess what you need to do to not see the rays?

By the way: for proximity sensors, blue rays mean nothing is detected close by, purple is when something is detected (`value > 0`); for camera, blue is when it's in line of sight, purple is when it's obstructed.

<span id="ais"/>
##e) Loading AIs from files
Haha, now we're playing. Who cares about coding, it's all about letting the AIs do the job! As fun as the external editor is, you can also directly load AIs (unfortunately not updating the code used in the text editor, bummer... be sure to upload it if you want to update the code). This is a good way to run directly your favorite AI or even more important **to make AIs battle each other**. Yep.

So, to load a specific .lua file as your AI, you just need to add a `script` parameter to the `<params>` tag inside your `<lua_controller>` tag. This would look like: `<params script="./battleAI.lua"/>`. Glorious.

Now if you actually want to make Player Vs Player, or should I say, AI Vs AI, you need to do a few things. First, create another (or as many as wanted) `<lua_controller>` with different `id` parameters. you should have something along the lines of:

```xml
<controllers>

    <lua_controller id="lua_AI_1">
        <actuators>
            <!-- bla bla bla your code --> 
        </actuators>
        <sensors>
            <!-- bla bla bla your code -->
        </sensors>
        <params/ script="./AI_1.lua">
    </lua_controller>

    <lua_controller id="lua_AI_2">
        <actuators>
            <!-- bla bla bla your code --> 
        </actuators>
        <sensors>
            <!-- bla bla bla your code -->
        </sensors>
        <params script="./AI_2.lua"/>
    </lua_controller>

</controllers>
```

Then you need to instantiate them (you spawned the brains, time to spawn the bodies). As mentioned twice already (fiou, last time), we'll use a distribute tag (actually, you can straight call a `<foot-bot>` tag). Just copy paste previous whole `<distribute>` tag that were used on a foot bot entity, and just change the `config` parameter to the name of the behavior you just created in the beginning of this section (here, lua_AI_1 and lua_AI_2).

Then sit back, relax, and enjoy the show!
