---
layout: default
title:  "Blink & Wink"
num: 2
---

When dealing with a whole swarm, stuff get much more complex pretty quickly. Simple stuff like moving in the same direction requires complex communication and decision making protocols (think of that next time you're watching ants). Past section introduced you to simple lone behavior, this section will not only introduce the usage of multiple robots but will have you communicate between each other. A swarm is not just a group of robot randomly acting, it's an entity behaving as one, usually aiming at displaying collective dynamic which are greater than the sum of each robot' behavior singled out (a classic in [gestalt](https://en.wikipedia.org/wiki/Gestalt_psychology)). In this section, we'll actually reuse most of previous code but with [MOAR](./assets/setup/setup_2.tar.gz) robots.

##a) Acting: may the force be with you (George, don't sue us)
So children, today we're going to learn about a new and exciting sensor! The treels, a portmanteau between wheels and déjà vu. Ok, my bad, been there done that. But not in this way. We'll learn a new paradigm of usage of those treels, one that is way more generic. We won't need no more endless `if then else`, no occasion to wonder how to mix two sub behaviors. We'll have one formalism to rule them all (Ok ok, I'll stop with the references...). We won't anymore drive the robot from the inside, we will command it from the outside. We won't feed it with speed, we will feed it with a direction and how much it should follow it or avoid it: a force, represented as a vector.

<img src="./assets/robot_wheels.png" alt="picture of the differential drive" style="float:right; margin:10px;">

In order to understand how such a force work, we need to get back to the differential drive picture. The robot is facing toward positive values of the X axis and positive value of the Y axis goes on its left. This means that a force over the X axis will correspond to a forward/backward speed and a force over the Y axis will correspond to an angular force. OK, seems clear enough? Clear enough or you to code out an implementation? :D Once you have cracked down some code, below is a working code , you can modify coefficients to fit your needs.

```lua
function speedFromForce(f)
    forwardSpeed = f.x * 1.0
    angularSpeed = f.y * 0.3

    leftSpeed  = forwardSpeed - angularSpeed
    rightSpeed = forwardSpeed + angularSpeed

    robot.wheels.set_velocity(leftSpeed,rightSpeed)
end
```

OK, and how can I use that? Well, you can feed the function with a force: `speedFromForce({x = 10, y = 20})`. Bam. Straight to the walls again (or its little sibling: rolling in circles). A step forward, let's create a random force:

```lua
function randForce(val)
    angle = robot.random.uniform(- math.pi/2, math.pi/2)
    randomForce = {x = val * math.cos(angle), y = val * math.sin(angle) }
    return randomForce
end
```

Such way of coding doesn't just do wonder when you try to command the robot but is perfect when coupling and weighting behaviors. Can you imagine a new way to handle the proximity sensors with this new paradigm? Maybe it's already time to fine tune your line follower algorithm, I'm sure you can save a few seconds on that previous lap! Below is an indication about how to code object avoidance. You will see this time the model is more generic and doesn't follow a case by case structure.

```lua
function proximityAvoidanceForce()
    avoidanceForce = {x = 0, y = 0}
    for i = 1,24 do
        -- "-100" for a strong repulsion 
        v = -100 * robot.proximity[i].value 
        a = robot.proximity[i].angle

        sensorForce = {x = v * math.cos(a), y = v * math.sin(a)}
        avoidanceForce.x = avoidanceForce.x + sensorForce.x
        avoidanceForce.y = avoidanceForce.y + sensorForce.y
    end
    return avoidanceForce
end
```

In this code, we transform the sensing data from each proximity sensors into a force, sum them all up and return our value. We will just have to use that force to feed the `speedFromForce` function.

In order to use both behaviour at the same time, you just need to get both force, add them, and feed that to the `speedFromForce` function:

```lua
randF = randForce(20)
getOutF = proximityAvoidanceForce()

sumForce = {x=0, y=0}
sumForce.x = randF.x + getOutF.x
sumForce.y = randF.y + getOutF.y
```

## b) Acting: LED stands for Let Everybody Dance.

<img src="./assets/robot_leds.png" alt="leds actuator" style="float:right; margin:10px;">

Yes it does, or at least should. Each robot is equipped with 12 Light Emitting Diodes spread in circle around its cute little body and a last one on top of it (called the beacon). You can set their color with the `robot.set_single_color(idLED, colour)` where idLED is the number associated with the LED (1-12 for the one around, 13 for the beacon) and color is <!--either a table with three components (red, blue and green, between 0 and 255) or -->a string ("red", "blue"... try them!). Little bonus to set them all at once with other examples:

```lua
robot.leds.set_all_colors("blue")
robot.leds.set_single_color(13, "red")
```

Try to make them blink, robots love to blink. By the way, remember [Knight Rider](https://www.youtube.com/watch?v=Mo8Qls0HnWo)? Let's redo the little LED chaser at the front of the car. You can either do it at the front of the robot or all around. Classic always fit (don't let them tell you otherwise) so I'll go for a front chaser. Graow. So, how to do so? Smoke and mirrors, all smoke and mirrors:

```lua
-- defined globally
cpt = 1
up = true
```

```lua
-- In the step function

-- update of the counter
if(up) then
  cpt = cpt + 1
else
  cpt = cpt - 1
end

if(cpt>3) then
  up = false
end

if(cpt<1) then
  up = true
end


-- display
robot.leds.set_all_colors("black")

cptToLed = {11,12,1,2} -- To get right offset of LEDs
robot.leds.set_single_color( cptToLed[cpt] ,"red")
```

Mad skillz for mad stylez. Ok, maybe more on the mad side than the mad style, it's moving pretty fast. You can either run it step by step to see the evolution or ... make a counter/timer which will trigger this behavior each *n* ticks so that it doesn't go so fast. Spoiler alert: this timer will make next code way easier to visually debug!

##c) Sensing: Open your eyes
For now, if we can appreciate our gorgeous LEDs at work, the robots can't. And that's a full scale shame. Let's solve that issue by accessing the robots camera. So, here some might think we're cheating. We won't use a front facing camera, but an omnidirectional one. Curious about the weird tower on top of the robot? Well, there is a semi spherical mirror on top of it, an under it a camera facing it. The resulting image is a 360° picture of the surrounding of the robots.

While the image processor pros will have a load of fun playing with the live stream, we'll get something simpler: a blob detection. This is not an alien spotter, but an algorithm that will output a list of small light detected (LEDs in the arena, such as the ones on the robot). A blob is defined by ts color and it's position. For the camera to work, we need first to call `robot.colored_blob_omnidirectional_camera.enable()` in the `init` function. **Don't forget that.** 'cause I sure did many times... The following code explains how the camera works. You'll note the usage of `#`. This operator when prefix of a table will output its size. Very useful when you don't know it before hand!

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

Ok, text log are pretty great (they still are), but didn't start lacking any less since last time when you prefer overall view over precision. Bla bla bla reference material. Like for the proximity sensor, if you remember how, update by yourself the .argos setup file, if you're hesitating a bit, we have you [covered](./ref_setup.html#debug).

##d) Behaving: blink my minions, blink as one!
Welcome to the wonderful world of robot communication. With the tools you have already at hands, you can create pretty complex behaviors. A simple and direct application would be using random robots as rally points (tell them to light up their beacons when on places of special interest, and make robots move toward that a specific light color). 

Let's see something a bit different, where we can see a more complex behavior emerge, information sharing and convergence toward an agreement. There is a classic task to do that fits all those points: synchronization. In our case, robots will blink their LEDs at a specific frequency, but not all of them together. The point of the game is to create an artificial intelligence that will not only allow two robots to synchronize, but a whole swarm. Bonus point if the swarm is moving.

First let's make robots blink regularly. Just create a counter, and when switching back to zero, you blink your LEDs. Below is a proposed solution.

First define a few stuff global:

```lua
-- On top of the file, defined as global
t = 0
tmax = 0
```

Then instantiate it:


```lua
function init()
    robot.colored_blob_omnidirectional_camera.enable()
    tmax = 100
    t = math.floor( math.random(0,tmax) )
end
```

And as for the blinking behavior:

```lua
function step()

    --Blinking

    t = t + 1

    if(t<tmax) then
        t = t + 1
        robot.leds.set_single_color(13,"black")
    else
        t = 0
        robot.leds.set_single_color(13,"red")
    end

end
```

Now, for the synchronization and all, what could we do? Artificial Intelligence is like magic. When you know the trick it feels really less like magic, or, to quote Aperture Science, "the impossible is easy". But one should never forget that the interest of an intelligence is about what it can do, not so much about how it achieves its goal. Try to find a way to have your swarm synchronize, if only as an idea you would drop on paper. Once you got your brain all warm and fuzzy, feel free to look at the proposed solution.

One way to do so is to try to close the gap between the blinking of different robots time at a time. For that, whenever a robot see a blink while he isn't blinking, he will artificially add a portion of his counter to itself.

```lua
--Synchronisation
if(#robot.colored_blob_omnidirectional_camera > 0) then
  t = t + 0.2 * t
end
```

Here we only used *one* signal. Would you have a lot of robots emitting a signal or one, it doesn't change. What if it did? There are a lot of variation to explore (not just changing that magic 1.2 number!), you'll have the occasion to explore them in this section's game! By the way, if you want to use the little curved arrow meaning *restart*, don't forget to put some code in your *reset* function in order to well, reset and randomize back the behavior!

##d) Playing: Hive mind
So, easy pea right? But what if you're actually having your robots spawned randomly, sometimes out of reach? Getting more complex already. You need to regroup (ah! I know how to do that!), reach out, and synchronize. Ok, that's not too hard. But what if you play against someone and blink both with a different color? And what if ... you're allowed to cheat and blink as the color of the other one? Now it's getting insane, the good kind of insane! Try to battle against each other and see if you manage to get all your robots blinking at once while messing with the other ones! 

