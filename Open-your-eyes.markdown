---
layout: default
title:  "Open your eyes"
num: 4
---

Up until now we discovered sensors and actuators of robots which created mainly isolated behaviours. In this section, we'll see the coupling LEDs & camera in order to get a first taste of swarm behaviour.

##a) First, show

<img src="./assets/robot_leds.png" alt="leds actuator" style="float:right; margin:10px;">

Our robots have two kind of LEDs (little lights), 12 spread over a circle around its body and a 13th one on top of it (called the beacon). You can access them by using the `robot.set_single_color(idx, colour)` where *idx* is the number of the LEDSs and *colour* is a table with three component: red, blue & green. Below is an example to set some LEDs and a shortcuts:

```lua
-- Classic usage
col = {red=255, blue=255, green=0}
robot.leds.set_single_color(13, col) 

-- In order to set all LEDs at once
col = {red=255, blue=255, green=0}
robot.leds.set_all_colors(col)

-- Some color names work too  
robot.leds.set_single_color(1, "red")
robot.leds.set_single_color(5, "red")
robot.leds.set_single_color(9, "red") 
```

##b) Then, see
The light sensor is not enough to parse all this new information. We'll have to use a camera for that. Thanks to the brilliant mind that created ARGoS, we don't have to deal with computer vision. The camera sensor gives you a list of blobs (sight of LEDs), their distance & angles as well as their colour. On top of that, it's an omnidirectional camera, meaning that it is almost like a top view of the robot, you get information from all around. Feels like cheating? Maybe, but good is how it feels too :D

Since you're used by now on how sensors work, the logging code on its own should be enough for you to get a hang on how to use the sensor. The only new detail here is the usage of the "#" symbol. When used as a prefix to a table, it outputs the size of the table. Super useful in our case since the number of blobs seen is variable. Last, the sensor will only work if you enable it with the `robot.colored_blob_omnidirectional_camera.enable()` function, usually done in the *init* function already provided.

```lua
for i = 1, #robot.colored_blob_omnidirectional_camera do
	blob = robot.colored_blob_omnidirectional_camera[i]
	log("dist: " .. blob.distance)
	log("angle: " .. blob.angle)
	log("red: " .. blob.color.red ..
	    " / blue: " .. blob.color.blue ..
	    " / green: " .. blob.color.green)
end
```

The good news is that the hard part isn't anymore to have access to the sensors and actuators, the bad news is that the new hard part is what to do with them! Well, at least it gets more and more interesting!

##c) Last, interact
Welcome to the wonderful world of robot communication. With the tools you have already at hands, you can create pretty complex behaviours. A simple and direct application would be using random robots as rally points (tell them to light up their beacons when on places of special interest, and make robots move toward that a specific light colour). 

Let's see something a bit different, where we can see a more complex behaviour emerge, information sharing and convergence toward an agreement. There is a classic task to do that fits all those points: synchronisation. In our case, robots will blink their LEDs at a specific frequency, but not all of them together. The point of the game is to create an artificial intelligence that will not only allow two robots to synchronise, but a whole swarm. Bonus point if the swarm is moving.

First let's make robots blink regularly. Just create a counter, and when switching back to zero, you blink your LEDs. Below is a proposed solution:

```lua
-- On top of the file, defined as global
t = 0
tmax = 0

-- In the init function
tmax = 20
t = math.floor( math.random(0,tmax) )

-- In the step function
--Blinking
if(t<tmax) then
	t = t + 1
	robot.leds.set_single_color(13,"black")
else
	t = 0
	robot.leds.set_single_color(13,"red")
end
```

Now, for the synchronisation and all, what could we do? Artificial Intelligence is like magic. When you know the trick it feels really less like magic, or, to quote Aperture Science, "the impossible is easy". But one should never forget that the interest of an intelligence result on what it can do, not so much on how it achieves its goal. Try to find a way to have your swarm synchronise, if only as an idea you would drop on paper. Once you got your brain all warm and fuzzy, feel free to look at the proposed solution.

One way to do so is to try to close the gap between the blinking of different robots time at a time. For that, whenever a robot see a blink while he isn't blinking, he will artificially add a portion of his counter to itself.

```lua
--Synchronisation
if(#robot.colored_blob_omnidirectional_camera > 0) then
	t = 1.2 * t
end
```
##d) ==Beuuuuuu==

