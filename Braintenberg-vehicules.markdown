---
layout: default
title:  "Braintenberg Vehicles"
num: 4
---

I confess a particularly strong love for those so called vehicles. Spawning from the realm of cybernetics (no kidding), those vehicles demonstrate a few things. First, you don't need complex algorithm to output interesting behaviour. And most importantly, you don't need a complex brain for humans (and animals) to project high cognition an assume the robot is more intelligent (or even sentient) than he really is. This is to say a lot about how actually we might project way too much on the sentient level while observing other humans...

In this section, we will learn what makes tick such vehicles and address their different personalities. Then we'll try to couple them together in order to create ... well ... a lovely mess!

I highly recommend reading of the book ([pdf](http://ge.tt/1ivvhQu/v/0)) from Braintenberg on these vehicles.


##a) Vehicles and behaviours
Those vehicles are based on what we already know: forces of attraction and repulsion. They just add a little tweak to that by modulating the amplitude of this force depending on how close or far you are from what attracts/repulses you. So, we got two alternatives, attraction or repulsion, and strong force when close or when far, building up to 4 different personalities for the robots. Each have names, so fitting that in experiments, humans linked the displayed behaviours with their fitting personality names. Those are the four:

* **Lover** is attracted by the source, strongly when far from it, an grow slower as he gets closer to it. In short, he loves to cuddle and is eager to show it.
* **Aggressor** is attracted too, but goes faster as he gets closer to its prey. A hunter in mind, don't get too close to it.
* **Coward** is repulsed by the source, strongly when close to it and less to not at all when far from it. Come try to disturb it and it will flee. It is only happy when alone.
* **Explorer** is repulsed by the source too, and move faster when he's far from it. He likes to cartography places, getting slower when close to them, and faster when trying to reach new places.


##b) One function to rule them all
As we saw, while those are very different personalities, they all are base on a similar behaviour. Let's make a function that sums them all and that would trigger each personalities depending on some entry parameters. So, all in all, what do we need to do ?

* A way to chose which personality to trigger
* Checking if we see a light (with the camera, to get the distance)
* Put a max on the range of the camera
* Link the value of the force with either the distance or its opposite
* Link the sign of the value of the force with the attraction/repulsion
* Create and return such a force

That seems a lot to do, but you've done already most of it in previous sections. That plus a bit of applied logic and you should be good to go. Don't rush to it, but if you need it, below is a proposed solution:

```lua

function cameraForce(attraction, strong)
    camForce = {x = 0, y = 0}

    -- Check if there is a light seen
    if(#robot.colored_blob_omnidirectional_camera == 0) then
        return camForce
    end

    dist = robot.colored_blob_omnidirectional_camera[1].distance
    angle = robot.colored_blob_omnidirectional_camera[1].angle

    -- Max range defined at 80 cm
	 if(dist > 80) then
        return camForce
    end

    -- Strong or Weak reaction
    if(strong) then
        val = 35 * dist/80
    else
        val = 35 * (1 - dist/80)
    end

    -- Attraction or Repulsion
    if(not attraction) then
        val = - val
    end

    camForce.x = val * math.cos(angle)
    camForce.y = val * math.sin(angle)     	
    return camForce
end
```

Once you have this function, call it (with the parameters you want, like `camForce(true, true)`) in the step function like you did with others. And fall in awe at such robotic cuteness.

##c) Finite State Automaton
In life, people are not so simple to display only one personality, and robot aren't either. One way to model such variety in personality is to use [Finite State Automaton](http://en.wikipedia.org/wiki/Finite-state_machine) (FSA). All in all, they are just series of states with transitions that links them together.

In Lua, that means creating a global table of states, a global value for the current state, and one function for each state (yay, clean code!). In those function, you will have both the behaviour and the transitions.

As an example, let's have a robot that oscillate between lover, coward and random walk.

```lua
-- Define the global state and the table of behaviours
myState = "random_walk"
state = {}

-- Defines the three behaviours

function state.random_walk()
       -- Behavior

	sumForce = { x = 0, y = 0}
	-- Random force
   randomForce = randForce(35)
	sumForce.x = sumForce.x + randomForce.x
	sumForce.y = sumForce.y + randomForce.y

	-- Avoiding physical object
	avoidanceForce = avoidForce()
	sumForce.x = sumForce.x + avoidanceForce.x
	sumForce.y = sumForce.y + avoidanceForce.y

	speedFromForce(sumForce)

   -- Transition
    if(#robot.colored_blob_omnidirectional_camera > 0 and
        robot.colored_blob_omnidirectional_camera[1].distance > 50) then
        myState = "lover"
    end

end

function state.lover()
       -- Behavior

	sumForce = { x = 0, y = 0}
	-- Light force
	camForce = cameraForce(true,true)
	sumForce.x = sumForce.x + camForce.x
   sumForce.y = sumForce.y + camForce.y

	-- Avoiding physical object
	avoidanceForce = avoidForce()
	sumForce.x = sumForce.x + avoidanceForce.x
	sumForce.y = sumForce.y + avoidanceForce.y

	speedFromForce(sumForce)

   -- Transition
    if(#robot.colored_blob_omnidirectional_camera == 0) then
        myState = "random_walk"
    elseif(robot.colored_blob_omnidirectional_camera[1].distance <20) then
        myState = "coward"
    end
end

function state.coward()
       -- Behavior

	sumForce = { x = 0, y = 0}
	-- Light force
	camForce = cameraForce(true,true)
	sumForce.x = sumForce.x + camForce.x
   sumForce.y = sumForce.y + camForce.y

	-- Avoiding physical object
	avoidanceForce = avoidForce()
	sumForce.x = sumForce.x + avoidanceForce.x
	sumForce.y = sumForce.y + avoidanceForce.y

	speedFromForce(sumForce)

   -- Transition
    if(#robot.colored_blob_omnidirectional_camera == 0) then
        myState = "random_walk"
    else
	     if(robot.colored_blob_omnidirectional_camera[1].distance > 80) then
            myState = "random_walk"
        end
    end
end

-- Which gives us a pretty simple step function
function step()
    state[myState]()
end

```

From now on, you can couple whatever you just learn and create complex series of behaviours. Not just anymore a robot with reflexes but a well fitted artificial intelligence!

##c) Coupling behaviours
test on id to have different behaviours.
