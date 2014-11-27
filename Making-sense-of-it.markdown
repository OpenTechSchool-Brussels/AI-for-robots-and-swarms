---
layout: default
title:  "Making sense of it"
num: 2
---

While randomly rushing in the wall has its fun, let's use a few sensor so we can link the actions of our robots with what it perceives.

##a) Looking at your feet
Or at least in the same direction: here we'll see how the robot can detect gray level on the grounds. While not a super sexy super power, it's very useful to realise you're in a specific location.

<img src="./assets/robot_motor_ground.png" alt="ground sensor" style="float:right; margin:10px;">

The robot have 4 grounds sensors on its lower part, each reading the brightness of the ground under them. They output a value between 0 and 1; 0 for black and 1 for white, shades of gray for values in between.

Each readings is a table composed of *value* an *offset*. The value refers to the brightness and the offset to a vector for the position of the specific sensor stemming from the centre of the robot. Since we have 4 sensors, we have 4 of those readings. They are all contained in the `robot.motor_ground` table and can be accessed as follow:

```lua
log("----")
for i = 1,4 do
    log(robot.motor_ground[i].value)
    log(robot.motor_ground[i].offset.x .. " " ..
        robot.motor_ground[i].offset.y)
end
```
You might see dark spot on the area. Can you imagine a code that makes your robots converge on those? Believe it or not, you have every tool needed! Try your hands on a solution. If your curious, below is a potential solution.

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
else
    -- Random walk to explore
    speedFromForce( randForce(35) )
end
```

##b) Invisible touch

<img src="./assets/robot_proximity.png" alt="proximity sensor" style="float:right; margin:10px;">

In order to detect object around them, the robots are equipped with proximity sensors that reacts to physical object on a 10cm range. There are 24 of them, spread in a ring around the robot body. 

Each readings is a table composed of an *angle* in radians and a *value* between 0 and 1. The angle defines the position of the sensors and the value is as high as the object is close (0 means nothing is detected). They are all contained in the `robot.proximity` table and can be accessed as follow:

```lua
log("----")
for i = 1,24 do
    log("Angle: " .. robot.proximity[i].angle ..
        "Value: " .. robot.proximity[i].value)
end
```

On of the most common usage for the proximity sensors is to avoid obstacles (object, walls, other robots...). For that, we need to create a repulsion force for each reading, as strong as its value, then sum them together and apply the force. Try to think of a way to do it or even code it on your own, this is how you'll really progress.If you're stuck, below is a proposed solution.

First we create a function for getting the avoidance force:

```lua
function avoidForce()
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

Then we use it in a whole behaviour:

```lua
sumForce = { x = 0, y = 0}

-- Avoiding physical object
avoidanceForce = avoidForce()
sumForce.x = sumForce.x + avoidanceForce.x
sumForce.y = sumForce.y + avoidanceForce.y

-- Random walk
randomForce = randForce(35)
sumForce.x = sumForce.x + randomForce.x
sumForce.y = sumForce.y + randomForce.y

speedFromForce(sumForce)
```

Now we're getting somewhere!

##c) There shall be light

<img src="./assets/robot_light.png" alt="light sensor" style="float:right; margin:10px;">

Up until now, the robots had only very local information. Patch of colors under him or object near him. Here, we will use light sensors to detect light object at a distance.

The light sensor is working pretty much like the proximity sensors. 24 sensors all around the robot in circle, readings in the table `robot.light` with *value* and *angle* as keys. The neutral value, 0, means that no lights are detected, the value increase up until 1 when the light is closer to the robot. The example for logging purpose is pretty much the same:

```lua
log("----")
for i = 1,24 do
    log("Angle: " .. robot.light[i].angle ..
        "Value: " .. robot.light[i].value)
end
```

So, let's make robots move toward the light. It's actually virtually the same than what we did with the proximity sensor, just with another sensor, and you get rid of the leading minus (the *-* in previous *-10*) on the value of the sensor since it's an attraction, and not a repulsion. Try it on your own.

Below is a proposed solution with an added bonus. You'll see your robot is attracted from a bit too far away. Let's put a cap on the attraction of the light. Have an idea how? Yep, with a conditional testing.


First we create a function for getting the avoidance force:

```lua

function lightForce()
    lightAttractionForce = {x = 0, y = 0}
    for i = 1,24 do
        -- We cap the value if too low
        val = robot.light[i].value
        if(val < 0.5) then
            val = 0
        end
    
        -- "30" for a strong attraction 
        v = 30 * val 
        a = robot.light[i].angle

        sensorForce = {x = v * math.cos(a), y = v * math.sin(a)}
        lightAttractionForce.x = lightAttractionForce.x + sensorForce.x
        lightAttractionForce.y = lightAttractionForce.y + sensorForce.y
    end
    return lightAttractionForce
end
```

Then we use it in a whole behaviour:

```lua
sumForce = { x = 0, y = 0}

-- Avoiding physical object
avoidanceForce = avoidForce()
sumForce.x = sumForce.x + avoidanceForce.x
sumForce.y = sumForce.y + avoidanceForce.y

-- Going toward the light
lightGoingForce = lightForce()
sumForce.x = sumForce.x + lightGoingForce.x
sumForce.y = sumForce.y + lightGoingForce.y

-- Random walk
randomForce = randForce(35)
sumForce.x = sumForce.x + randomForce.x
sumForce.y = sumForce.y + randomForce.y

speedFromForce(sumForce)
```


##d) ==Follow the line==
Same than previously, no time yet to create the game...
