---
layout: default
title:  "Making sense of it"
num: 2

---

While randomly rushing in the wall has its fun, in order to display a more intelligent behavior, your robot needs to sense its environnement. Lucky you, that's what we're going to learn now!

##a) Having both wheels on the ground
Not only does that implies a realistic understanding, but also the capacity to sense this ground. Here we'll do the later!

The grounds sensors are 4 sensors on the lower part of the robot, aiming at the ground, in order to read its brightness. They output a value between 0 and 1; 0 for black and 1 for white, shade of gray in between.

PICTURES GROUND SENSORS

In our case, those readings contains a table composed of *value* an *offset*. The value refers to the brightness, and the offset to a vector for the position of the specific sensor stemming from the center of the robot:

```lua
    log("----")
    for i = 1,4 do
        log(robot.motor_ground[i].value)
        log(robot.motor_ground[i].offset.x .. " " .. robot.motor_ground[i].offset.x)
    end
```

This sensors allows you to localise place of interest in the arena. Can you imagine a code that would make your robots converge toward on dark spot on the arena ? Believe it or not, you have every tool needed! If your curious, below is a potential solution.

```lua
    -- Sense Ground
    valGround = 0
    for i = 1,4 do
        valGround = valGround + robot.motor_ground[i].value
    end
    
    -- Act upon the information
    if(valGround <= 2) then
        -- Stop when at least two sensors sense black
        robot.wheels.set_velocity(0,0)
        force = {x = 0, y = 0}    
    else
        -- Random walk to explore
        force = randForce(35)
    end

    -- Update speed with generated force
    speedFromForce(force)
```

Let's see now how to interact with physical objects.

##b) Invisible touch

In order to detect object around them, the robots are equipped with proximity sensors, 24 of them, spread in a ring aroung the robot body. Each sensor has a range of 10cm and returns a reading composed of an *angle* in radians and a *value* between 0 and 1. The angle defines the position of the sensors, and the value is as high as the object is close (0 means nothing is detected). The table containing those readings is `robot.proximity`

DESSIN PROXIMITY SENSOR

Here is an example of reading, for logging purpose:

```lua
    log("----")
    for i = 1,24 do
        log(robot.proximity[i].angle)
        log(robot.proximity[i].value)
    end
```

Beware: as you might have noted from the picture, the sensors are numbered counter clock wise, meaning that if you want to use the *angle* variable, you'll need to use the inverse of it.

On of the most common usage (but not the only one) for the proximity sensors is to avoid obstacles (would that be object on the path, or other robots). This one will be a bit tougher than previous example. Can you imagine how to do so? We reuse the force paradigm we had previously, but now we have many forces, one per readings. If I detect an object, I should not be attracted to it (as previous forces worked) but repulsed by it. So, one repulsion force per reading, you sum them up, add the random force, and then process the force to caluculate the speed. Hell, things are starting to get serious! Try to create the behavior by yoursel, and if you're get stuck, below is a working solution.

```lua
    sumForce = { x = 0, y = 0}

    for i = 1,24 do
        -- A "-" because it's repulsion force
        -- and "* 10" to make the force stronger 
        v = - robot.proximity[i].value * 10 
        a = robot.proximity[i].angle

        fAvoidance = {x = v * math.cos(-a), y = v * math.sin(-a)}
        sumForce.x = sumForce.x + fAvoidance.x
        sumForce.y = sumForce.y + fAvoidance.y
    end

    randomForce = randForce(35)
    sumForce.x = sumForce.x + randomForce.x
    sumForce.y = sumForce.y + randomForce.y

    speedFromForce(sumForce)
```

You might as well create a function for the avoidance part of the code, returning a force, as for the `randForce(val)` function. I'll let you do that one!

##c) There shall be light
You reach nowhere in life if all you do is avoiding stuff. This is why in this section we'll play with the light sensors, which usualy robots (as insects) loooove to go toward.

The light sensor is working pretty much like the proximity sensors. 24 sensors all around the robot in circle, readings in the table `robot.light` with *value* and *angle* as keys. The neutral value, 0, means that no lights are detected, the value increase up until 1 when the light is closer to the robot.

The example for logging purpose is pretty much the same:

```lua
    log("----")
    for i = 1,24 do
        log(robot.light[i].angle)
        log(robot.light[i].value)
    end
```

So, let's move toward the light. Have an idea of how to do that? You can base your code on the avoidance code. It's the same, more or less minus one thing. Below is a proposed solution.

```lua
    sumForce = { x = 0, y = 0}

    for i = 1,24 do
        -- Same than previously, without the minus
        v = robot.light[i].value * 10
        a = robot.light[i].angle

        fLight = {x = v * math.cos(-a), y = v * math.sin(-a)}
        sumForce.x = sumForce.x + fLight.x
        sumForce.y = sumForce.y + fLight.y
    end

    randomForce = randForce(5)
    sumForce.x = sumForce.x + randomForce.x
    sumForce.y = sumForce.y + randomForce.y

    speedFromForce(sumForce)
```


##d) ==Free for all== 
Same than previously, no time yet to create the game...
