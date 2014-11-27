---
layout: default
title:  "Let's get rolling"
num: 1
---

The way you command anything that move is linked with the actuators responsible for its moving. You won't control a car, a 4 leg robot or a rocket the same way. In this section we'll discover how to command your robot, and build better ways to do so.

<img src="./assets/marxbot.jpg" alt="picture of the marxbot" style="height:300px; float:right;">

## a) One robot, two wheels
Actually, they are "treels", some neologism between wheels and trails. But for all your concern, you can see the robot as a segway: two wheels along the horizontal axis.

Your robot will move thanks to these wheels, and for that you need to order those wheels to roll at a specifid speed. This is done through the `robot.wheels.set_velocity(leftS, rightS)` function, accepting two values (left and right speed) as parameters, both measured in cm/s. Positive values will make wheels roll forward, negative will make them roll backward.

Try to play with varying speed for each wheels, and espcially, try to make your robot move in a straight line forwar, and then try to make it rotate on itself.

## b) Forward speed & angular speed
So, if you tryed already to give more complex navigational behavior from this simple function, you'll realise it's not the most straight forward way to code the moving of the robot. You might rather want to pilote your robot as you would pilote a car: thinking in terms of moving forward/backward and turning would already be a step forward, and one we'll make right now.

How to know what values to feed both wheels when you know the forward speed and angular speed? This depends on the way your robot move, and in our case, with those two wheels, it's defined by a system called differential drive.

![differential drive](./assets/robot_wheels.png)

If you did previous step experiment, you'll have seen that moving forward means having same speed on both wheels, while turning on yourself implies having oposite speed. In our case we'll just combine the two in order to have the full behavior (moving forward/backward & turning).

```lua
    forward = 10
    angular = 1

    leftSpeed = forward - angular
    rightSpeed = forward + angular

    robot.wheels.set_velocity(leftSpeed,rightSpeed)
```

## c) Forces of attraction
While concept of foward/backward and turning are fitting when you are piloting the robot from the inside, this is not exactly what would fit best in our context. We want to be able to command the robot and giving him order: avoiding stuff, going to places... Those orders can be seen as forces, attraction for places you want to go to, repulsion for places you want to avoid. We will represent those forces using vectors.

Being in 2D, a vector will only have an x and y component. In lua, a vector can be described through a table structure: ` vector = { x = 0, y = 0}`. You can then simply use and affect those values: `vector.x = 2`.

The most astute will have seen that in the robot frame of reference, the x axis is vertical forward while the y axis is horizontal toward left. This is in order to use the z axis goind through the robot, in the up direction.

If you project your force vector on the x and y axis, you will get two components, respectively fitting the forward and angular concepts we defined earlier. Indeed, a value along the x axis means that your robot is pushed going forward or backward, and a value along the y axis implis that your robot is pushed rotating on itself.

This means that once a force is defined, you can use the following code to control your robot:
 

```lua
    force = {x =10, y=5}

    forward = force.x * 1.0 -- Those multiplyng factors define how strong
    angular = force.y * 0.3 -- the robot turns and moves forward 

    leftSpeed = forward - angular
    rightSpeed = forward + angular

    robot.wheels.set_velocity(leftSpeed,rightSpeed)
```

Once satisfied with the behavior, you can even sum up the previous lines in only one (plus the definition of the force).

Not only does this allow a more human way of controlling the robot, it's also a very generic way to control it. For instance, when many forces are applied to the robot, you only need to add them before applying the previous snippnet of code.

Since it'll be a piece of code we'll reuse a lot and won't change much (if at al), let's make it a function that takes a force as input, and setup the speed of the wheels:

```lua
function speedFromForce(f)
    kF = 1.0 
    kA = 1.0 

    forward = f.x * kF
    angular = f.y * kA

    leftSpeed = forward - angular
    rightSpeed = forward + angular

    robot.wheels.set_velocity(leftSpeed,rightSpeed)
end
```

You could parametrise this function a lot already. On top of using *kF* and *kA* to control the impact of forward and angular force, you might want to only allow forward movement (meaning only positive *forward* value), saturate your speed, or even only allow one speed (so the force only define the direction)...

Armed with this function, we can already create some interesting, if simple, behaviors.

## d) Random walk
If artificial intelligent is always artificial, it's not always as intelligent as one might think in advance. Some times randomness is enough, and it's the power of chaos we'll feed on here. You can (and should in the context of our simulaton) access random values in the `robot.random` table. See in the references the many possibilities, but the one we'll be starting with is the `robot.random.uniform(min,max)` function, which will randomly chose a number between the min and max parameter.

A random walk is a common mean of exploiting an area. While randomness is something you use, it's not always a straight use. Try to put random values for the speed of your wheels and you'll see what I mean. In our case, we'll force the robot to move forward but in any direction he wants. For that, we want a force that is always of amplitude 1, and with an angle between -Pi/2 and Pi/2. Ahhh, trigonometry, between that and banging your head on your desk...

Actually, not that hard. We'll be using the `math` library for everything math related. Such a fitting name for the library.

```lua
    angle = robot.random.uniform(- math.pi/2, math.pi/2)
    randForce = {x = 35 * math.cos(angle), y = 35 * math.sin(angle) }
    speedFromForce(randForce)
```

One could even make a function out of it that returns a vector (as a table):

```lua
function randForce(val)
    angle = robot.random.uniform(- math.pi/2, math.pi/2)
    randomForce = {x = val * math.cos(angle), y = val * math.sin(angle) }
    return randomForce
end
```

In order to use it, just call it and affect the return value to a table `f = randForce(35)`.

## e) ==Fog of war==
No luck Mario, your princess is in another castle... This part will be done for the next workshop!
This section's Game: covering arena as best as you can.

