---
layout: default
title:  "Regroup & Reach"
num: 2
---

When dealing with a whole swarm, stuff get much more complex pretty quickly. Simple stuff like moving in the same direction requires complex communication and decision making protocols (think of that next time you're watching ants). Past section introduced you to simple lone behavior, this section will not only introduce the usage of multiple robots but will have you communicate between each other. A swarm is not just a group of robot randomly acting, it's an entity behaving as one, usually aiming at displaying collective dynamic which are greater than the sum of each robot' behavior singled out (a classic in [gestalt](https://en.wikipedia.org/wiki/Gestalt_psychology))

##a) May the force be with you (George, don't sue us)
So children, today we're going to learn about a new and exciting sensor! The treels, a portmanteau between wheels and déjà vu. Ok, my bad, been there done that. But not in this way. We'll learn a new paradigm of usage of those treels, one that is way more generic. We won't need no more endless `if then else`, no occasion to wonder how to mix two sub behaviors. We'll have one formalism to rule them all (Ok ok, I'll stop with the references...). We won't anymore drive the robot from the inside, we will command it from the outside. We won't feed it with speed, we will feed it with a direction and how much it should follow it or avoid it: a force, represented as a vector.

<img src="./assets/robot_wheels.png" alt="picture of the differential drive" style="float:right; margin:10px;">

In order to understand how such a force work, we need to get back to the differential drive picture. The robot is facing toward positive values of the Y axis and positive value of the X axis goes on its left. This means that a force over the Y axis will correspond to a forward/backward speed and a force over the X axis will correspond to an angular force. Below is a working code of such an implementation, you can modify coefficients to fit your needs.

```lua
function speedFromForce(f)
    forwardSpeed = f.x * 1.0
    angularSpeed = f.y * 0.3

    leftSpeed  = forwardSpeed - angularSpeed
    rightSpeed = forwardSpeed + angularSpeed

    robot.wheels.set_velocity(leftSpeed,rightSpeed)
end
```

## b) Acting: LED stands for Let Everybody Dance.

<img src="./assets/robot_leds.png" alt="leds actuator" style="float:right; margin:10px;">

Yes it does, or at least should. Each robot is equipped with 12 Light Emitting Diodes spread in circle around its cute little body and a last one on top of it (called the beacon). You can set their color with the `robot.set_single_color(idLED, colour)` where idLED is the number associated with the LED (1-12 for the one around, 13 for the beacon) and color is either a table with three components (red, blue and green, between 0 and 255) or a string ("red", "blue"... try them!). Little bonus to set them all at once with other examples:

```lua
col = {red=255, blue=255, green=0}
-- In order to set all LEDs at once
robot.leds.set_all_colors(col)

robot.leds.set_single_color(1, "red")
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
if(up)
  cpt = cpt + 1
else
  cpt = cpt - 1
end

if(cpt>3)
  up = false

if(cpt<1)
  up = true

-- display
robot.leds.set_all_colors("black")	
robots.leds.set_single_color( (22 + cpt)%25 + 1,"red") -- yep
```

Mad skillz for mad stylez.

##c) Sensing: Open your eyes
For now, if we can appreciate our gorgeous LEDs at work, the robots can't. And that's a full scale shame. Let's solve that issue by accessing the robots camera. So, here some might think we're cheating. We won't use a front facing camera, but an omnidirectional one. Curious about the weird tower on top of the robot? Well, there is a semi spherical mirror on top of it, an under it a camera facing it. The resulting image is a 360° picture of the surrounding of the robots.

While the image processor pros will have a load of fun playing with the live stream, we'll get something simpler: a blob detection. This is not an alien spotter, but an algorithm that will output a list of small light detected (LEDs in the arena, such as the ones on the robot). A blob is defined by ts color and it's position. For the camera to work, we need first to call `robot.colored_blob_omnidirectional_camera.enable()` in the `init` function. The following code explains how the camera works. You'll note the usage of `#`. This operator when prefix of a table will output its size. Very useful when you don't know it before hand!

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
