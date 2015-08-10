---
layout: default
title:  "Regroup & Reach"
num: 2
---

When dealing with a whole swarm, stuff get much more complex pretty quickly. Simple stuff like moving in the same direction requires complex communication and decision making protocols (think of that next time you're watching ants). Past section introduced you to simple lone behavior, this section will not only introduce the usage of multiple robots but will have you communicate between each other. A swarm is not just a group of robot randomly acting, it's an entity behaving as one, usually aiming at displaying collective dynamic which are greater than the sum of each robot' behavior singled out (a classic in [gestalt](https://en.wikipedia.org/wiki/Gestalt_psychology))

##a) Acting: may the force be with you (George, don't sue us)
So children, today we're going to learn about a new and exciting sensor! The treels, a portmanteau between wheels and déjà vu. Ok, my bad, been there done that. But not in this way. We'll learn a new paradigm of usage of those treels, one that is way more generic. We won't need no more endless `if then else`, no occasion to wonder how to mix two sub behaviors. We'll have one formalism to rule them all (Ok ok, I'll stop with the references...). We won't anymore drive the robot from the inside, we will command it from the outside. We won't feed it with speed, we will feed it with a direction and how much it should follow it or avoid it: a force, represented as a vector.

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

    
