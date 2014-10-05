---
layout: default
title:  "Knocking some sense into it"
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
        angle = robot.random.uniform(- math.pi/2, math.pi/2)
        force = {x = 35 * math.cos(angle), y = 35 * math.sin(angle) }
    end

    -- Update speed with generated force
    speedFromForce(force)
```

Ground sensors (?)
    knowing when you're arrived: reaching places = LOCALISE

##b) As close as you can get
Proximity sensor
    add obstacle to the path: obstacle avoidance = NAVIGATE

##c) Moving toward the light
Light sensor
    Locating the light (do we get distance or just angle?)
    If distance too => Braintenberg vehicules :D
    If not, then we'll use the camera...
    
##d) Braintenberg vehicules (yay! :D :D)
I confess a particularly strong love for those so called vehicules.

##e) ==Free for all== 
This section's Game = Something based on Braintenberg vehicules! 

