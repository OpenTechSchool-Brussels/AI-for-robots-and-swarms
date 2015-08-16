---
layout: default
title:  "Braintenberg Vehicles"
num: 3
---

I confess a particularly strong love for those so called vehicles. Spawning from the realm of cybernetics (no kidding), those vehicles demonstrate a few things. First, you don't need complex algorithm to output interesting behavior. And most importantly, you don't need a complex brain for humans (and animals) to project high cognition and to assume that the robot is more intelligent (or even sentient) than he really is. This is to say a little about robotics, and a lot about how actually we might project way too much on the sentient level while observing other humans... In this section, we will learn what makes tick such vehicles and address their different personalities. Then we'll try to couple them together in order to create ... well ... a lovely mess! I highly recommend the reading of the book ([pdf](http://ge.tt/1ivvhQu/v/0)) from Braintenberg on these vehicles. In this section, we'll actually use previous setup files.

##a) Vehicles and behaviors
Those vehicles are based on rules of attraction and repulsion: what makes you tick, what you seek in life (don't get already tired of the metaphor, more is coming your way!). Such concept while being super vague, is actually super simple to put in motion. Both sums up as the reason why with so little one will project so much. We will have four different behaviors, separated only by two variable characterizing if you are attracted or repulsed, and how much you are depending on your remoteness toward your reference (the source). Different signs of such variables will make different behavior (hence 4 behavior), different values within the same sign will temper the same behavior.

Those 4 behaviors really act as personalities for the robots. Each have names, so fitting that in experiments, humans linked the displayed behaviors with their fitting personality names.

* **Lover** is attracted by the source, strongly when far from it, an grow slower as he gets closer to it. In short, he loves to cuddle and is eager to show it. `Force = + distance`
* **Aggressor** is attracted too, but goes faster as he gets closer to its prey. A hunter in mind, don't get too close to it if you don't want to be jumped on.  `Force = + 1/distance`
* **Coward** is repulsed by the source, strongly when close to it and less to not at all when far from it. Come try to disturb it and it will flee. It is only happy when alone.  `Force = - 1/distance`
* **Explorer** is repulsed by the source too, and move faster when he's far from it. He likes to cartography places, getting slower when close to them, and faster when trying to reach new places.  `Force = - distance`

In our case, the sensing will be done by the camera and the source can be any light. An LED over an item, a light source in the arena, or way more fun: the LEDs from other robots! Create a group of cat like aggressor and see how the coward mouse will react...

##b) One size fits them all
While we could create one function for each behavior, we saw that they are actually pretty linked together. Let's create one that will take two parameters in entry, patterns of attractions and patterns of reaction to distance. Can you imagine such function? It should check for a light (or multiple ones), truncate it over a max value, and then returns a force depending on the two patterns we feed the function. That seems a lot to do, but you've done already most of it in previous sections. That plus a bit of applied logic and you should be good to go. Don't rush to it, but if you need it, below is a proposed solution for one blob:

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

Once you have this function, call it (with the parameters you want, like `camForce(true, true)`) in the step function like you did with others. And fall in awe at such robotic cuteness:

```lua
vForce = camForce(true,true)
speedFromForce(vForce)
```

For it to work best, you need interesting patterns of light. While you could create a light with ARGoS, better actually create a robot that will play the role of a light. Create another AI with very simple behavior (running in circle, avoidance or ... following a line and others!), and see how your vehicle respond to it!

##c) Finite State Automaton
In life, people are not so simple to display only one personality, and robot aren't either. One way to model such variety in personality is to use [Finite State Automaton](http://en.wikipedia.org/wiki/Finite-state_machine) (FSA). All in all, they are just series of states with transitions that links them together.

In Lua, that means creating a global table of states, a global value for the current state, and one function for each state (yay, clean code!). In those function, you will have both the behavior and the transitions.

As an example, let's have a robot that oscillate between coward and random walk.

```lua
-- Variable defined globally at the top
myState = "random_walk"
state = {}
```

```lua
-- Functions defined globally

function state.random_walk()
  -- Behavior
    -- already coded elsewhere
    
  -- Transition
  if(#robot.colored_blob_omnidirectional_camera > 0 and
    robot.colored_blob_omnidirectional_camera[1].distance < 50) then
    myState = "coward"
  end
end


function state.coward()
  -- Behavior
    -- already coded elsewhere	

  -- Transition
  if(#robot.colored_blob_omnidirectional_camera or
     robot.colored_blob_omnidirectional_camera[1].distance > 70) then
    myState = "random_walk"
  end
end
```

Ok, from there, we'll have a pretty simple step function. Its only main is to actually call the function of the state table associated with the string of our current state:

```lua
function step()
    state[myState]()
end
```

This tool is particularly useful when you need to separate your task in multiple sub-task and have your robot behave in a difference way depending on the situation at hand. Another nice usage is to create heterogeneous swarms. Just call different functions depending on the value of `robot.id`. This allow you for instance to have behaviors of robot that answer each other, playing tag and such. You can create already a little artificial life simulation of your own here. Below is a little code example to start from.


```lua
-- In step function
if( robot.id % 2 == 0) then -- Check if even 
    state("random_walk")
else
    state("coward")
end
```

Tadam! Now you have everything to create complex teams and strategy to apply back to all previous games. Oh, but let's add one more.

##d) Playing: Regroup & rejoice
Easy: regroup on the white areas. What? But we already did that! That's true, but you did that without communication. Now that you have complex patterns of communicating, try to see how that could affect your previous efficiency. For added bonus, you might want to compete for real estate with another AI! Or ... create another map with black and white spots. One need to reach the black ones, the other the white ones. But as always, cheating is okay so you can storm on the other's spots to make them appear full!

