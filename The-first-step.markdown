---
layout: default
title:  "Let's get rolling"
num: 1
---

INTRO = GAME as objective, and setup files.

Basic rule of life: if you don't move, things are going to get pretty hard up the road... Now different creature and inventors found various way to solve that issue. Those answers doesn't work the same way, you don't control a car, a 4 leg robot or a rocket the same way. In this section we'll discover how to make your robot move and then we'll create better way to command it.

<img src="./assets/marxbot.jpg" alt="picture of the marxbot" style="height:300px; float:right; margin:10px;">

## a) One robot, two wheels
Actually, they are *treels*, a portmanteau neologism of wheels and trails. But for all your concern, you can see the robot as two wheels along the horizontal axis. Controlling your robot movement will go through setting the speed of each of those wheels. For that we use the `robot.wheels.set_velocity(leftSpeed, rightSpeed)` function which accept two values (yep, left and right speed) as parameters, both measured in cm/s. Positive values will make wheels roll forward, negative will make them roll backward.

Try to play with varying speed for each wheels, for instance:

* moving straight (leftSpeed = rightSpeed)
* turning right (leftSpeed > rightSpeed)
* turning on your self (leftSpeed = -rightSpeed) 

## b) Forward speed & angular speed
Setting the wheels speed does the job, but not in a very straight forward manner. You might want to control your robot more like a car: thinking in terms of moving forward/backward and turning. 

As you saw in previous section, in order to move straight, you need both wheels speed to be the same, and in order to turn on yourself, you need to have opposite speed on each wheels. In order to think in matter of going forward and backward, we'll just composite both:

```lua
forwardSpeed = 10
angularSpeed = 1

-- We have an equal component, and an opposed one   
leftSpeed   = forwardSpeed - angularSpeed
rightSpeed = forwardSpeed + angularSpeed

robot.wheels.set_velocity(leftSpeed,rightSpeed)
```

That's good. But we don't want to pilot our robots as a car (from the inside) we want to give him orders (from the outside). In this context, thinking in terms of forward & turning, while being an improvement, is still not an useful enough vocabulary for that.


## c) Forces of attraction
Orders can be seen as forces (attraction: go there, repulsion: avoid that) and forces are best represented as vectors. Let's use that to create a more human way to control that robot. Being in 2D, a force vector will only have an x and y component. In Lua, vectors are described as a table structure:

```Lua
 -- Define your table/vector/force
force = { x = 0, y = 0}`.

-- Setting up table/vector/force values
force.x = 10
force.y = 10

-- Using table/vector/force values
sum = force.x + force.y
```

<img src="./assets/robot_wheels.png" alt="picture of the differential drive" style="float:right; margin:10px;">

If you look at the reference on the right, you will see that in order to have a coherent 3D axis, and a z going through the robot in the up direction, we ended up have the x axis vertical forward and the y axis horizontal left. This means that the *force.x* component of the force will impact forward/backward movement (force.x > 0 implies forward movement) and the *force.y* component will impact turning (force.y > 0 implies turning on the left, since the y axis goes toward the left). All in all, here it how it looks like in code:

```lua
force = {x =10, y=5}

 -- The multiplying factors define how strong
 -- the robot turns and moves forward 
forwardSpeed = force.x * 1.0
angularSpeed = force.y * 0.3

leftSpeed   = forwardSpeed - angularSpeed
rightSpeed = forwardSpeed + angularSpeed

robot.wheels.set_velocity(leftSpeed,rightSpeed)
```

Not only does this allow for a more human way to control the robot, it's also a very generic way to control it. For instance, when many forces are applied to the robot, you only need to add them before applying the previous snippet of code, how great is that?!

Since it'll be a piece of code we'll reuse a lot and won't change much (if at all), let's make it a function that takes a force as input, and setup the speed of the wheels:

```lua
function speedFromForce(f)
    forwardSpeed = f.x * 1.0
    angularSpeed = f.y * 0.3

    leftSpeed   = forwardSpeed - angularSpeed
    rightSpeed = forwardSpeed + angularSpeed

    robot.wheels.set_velocity(leftSpeed,rightSpeed)
end
```

You could parametrise this function a lot already. On top of modifying the multiplying factors that controls the impact of forward and angular force, you might want to only allow forward movement (i.e. only positive *forward* value), saturate your speed, or even force a high speed so the force only define the direction...

Armed with this function, we can already create some interesting, if simple, behaviours.

## d) Random walk
If artificial intelligent is always artificial, it's not always as intelligent as one might think in advance. Some times randomness is enough.

We'll tap in the power of chaos to let our robot explore the arena in a suitable way. You can (and should, in the context of our simulation) access random values through the `robot.random` table. See in the references the many possibilities, but the one we'll be starting with is the `robot.random.uniform(min,max)` function, which will randomly chose a number between the min and max parameter.

A random walk is a common way of exploring an area. While randomness is something you use, it's not always a straight use. Try to put random values for the speed of your wheels and you'll see what I mean. In our case, while we'll have random direction, we'll force the robot to move forward and at a constant speed. Try to process what could mean each part of previous sentence in terms of code.

Since we'll guide the robot, we'll use a force. A constant speed means that our random force will always have the same amplitude. A random direction means that it can be between -pi & pi. Only moving forward means that we restrict angles that would make the robot go backward, which leaves us with the [-pi/2, pi/2] range.

Now, how on hell can you create a vector not based on x & y componant, but defined by an amplitude and a vector? Through the magic of trigonometry. If we use k for amplitude and a for angle: `vec = {x = k * math.cos(a), y = k * math.sin(a) }`

Try to think on how to bring together all those Lego bricks to get the random walk of your dreams. If you're curious, below is a proposed solution:

```lua
angle = robot.random.uniform(- math.pi/2, math.pi/2)

randForce = {x = 35 * math.cos(angle),
                     y = 35 * math.sin(angle) }

speedFromForce(randForce)
```

Since this will be super useful, let's make a function out of it in order to have a cleaner code. It take a power parameter in input, and returns a vector (as a table):

```lua
function randForce(val)
    angle = robot.random.uniform(- math.pi/2, math.pi/2)
    randomForce = {x = val * math.cos(angle), y = val * math.sin(angle) }
    return randomForce
end
```

In order to use it, just call it and affect the return value to a table `f = randForce(35)` or even quicker: `speedFromForce( randForce(35) )`.

## e) ==Fog of war==
Ok, not yet a game here, will need to work on that, and shift a bit this part (specially the intro) to create a bigger motivation toward achieving the task in the game.
