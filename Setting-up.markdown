---
layout: default
title:  "Setting up"
num: 0
---

So, before creating [robots discarding collected intel and driving into walls](http://bash.org/?240849), let's setup all the necessary tools and get a bit of context. Both are as necessary: one to do things, the other to understand what you're doing!

##a) ARGoS Simulator
In order to simulate both our robots and their environment, we'll use [ARGoS](http://www.argos-sim.info/), a multi-physics robot simulator easily customizable by adding new plug-ins. It can efficiently simulate large-scale swarms of robots. Its accuracy aims to be as close as possible to real simulation. It's a tool created with research in mind and used all around the world in laboratories. While we will use it as an educational tool and later as a gaming platform, its constrains & quality are the same than such that would be required by a professional and research environment. In short: whatever you will create here will have real sense. If your behaviour is getting amazing result on a task, be ready to publish about it, yay!

ARGoS takes three things as entry points:

* the robot brain (either C++ code or Lua code);
* an environment code (only in C++), either to update the environment's information (like adding objects) or to add more visuals;
* a .argos (XML) file describing the experimental conditions.

The environment code (loop functions) will be given to you when needed, nothing to worry or care much about. While the .argos files will be given to you too, we will have a look at it together and you might have to change a few parameters along the way (changing the number of robots, the position of places of interest...). The files we provide are meant to be sufficiently commented for you to be able to work it out on your own. Last, and most important: the brain of the robots. This is what we'll be mainly working on in this workshop. While C++ could be used, we will focus on Lua because it makes the whole process easier. If you don't know Lua, don't worry, it's similar to classic programming language.

Three references pages are provided to you. One on [ARGoS](./ref_argos.html) and another on [Lua](./ref_lua.html) (taken from reference material of Carlo Pinciroli's course on Swarm Intelligence). The [third](./ref_setup.html) is about the .argos XML file and will help in creating new setups. Be sure to come back to those three refs when not sure about what you're doing.

##b) Setting Up ARGoS & Lua
You can either install ARGoS from source or directly from packages. The later should be simpler. Only fall back to the former if you can't make it work, or if you want cutting edge code. Installation can be done on Mac and Linux, alas no possibility for Windows. To install from package, go [there](http://www.argos-sim.info/core.php); to install from source, check [here](https://github.com/ilpincy/argos3/).

In order to check if ARGoS is well installed, just type `argos3 --version`, a green text should appear with the version name of currently installed ARGoS.

##c) Your first code
Let's release the beast. When launching experiments in ARGoS, you need to feed it with an experimental setup file  (the .argos file), announced with the command line flag `-c`, c standing for configuration. It goes likes: `argos3 -c expSetup.argos`. As mentioned earlier, you won't need to deal much with configuration files. You can download [here](./assets/setup/setup_0.tar.gz) the configuration file which we will use as well as the picture we will use for the ground floor. Create a working directory, put the files there, open your command line in this directory, launch `argos3 -c setup.argos` and voilà! 

You should see two windows appearing. One is a text editor (where you will type your Lua code), the other one is the ARGoS simulator itself (where you will see the lovely little robots moving and behaving erraticly).

You will find in the simulator a view of your arena on the centre, two text area for logging purposes on the right, and some control on the top (play, stop, step by step, forward, reset, screen-shot, camera options...). Play launches the simulation, other buttons behave as expected in such context.

In the Lua code editor, you will find that there are already some functions defined, giving your code a structure. As already well explained in the comments, they are:

* **init** called once at the creation of the robots
* **step** called at each step of the experiment
* **reset** called when the reset button is pressed
* **destroy** called at the end of the experiment

On top of all the power of Lua, ARGoS provide you with a specific container, adequately called `robot`. Anything robot related (sensor & actuator) will go through it. Another thing to keep in mind, printing stuff doesn't go through the classic `print` Lua function, but through the ARGoS `log` function that re-routs printing to the logging text areas of the simulator.

Let's launch our first experimentation to better understand what's happening. 
Type inside the step function the following line, where `robot.id` refers to the robot own identification number.

```Lua
log("Hello, my name is " .. robot.id)
```

Apart from the classic text editor functionality, you'll see on the right end a little gear icon. Click on it (or press **Ctrl-E**) to execute your code. The code is then loaded in the ARGoS simulator, and you just have to press play to discover its wonder. Which isn't much yet (Yes, the robot can move. They are just sleepy right now). On the right side, you'll see time steps and logging information. The simulation of the world here is executed steps by steps. At each steps (or ticks), the function `step` is called for each robots, and is resolved.

##d) ARGoS UI
So, your simulation is in place, how do you use it? Well, the button on the top are a bit straight forward. Play plays the simulation, stop stops it, forward makes it quick (how quick? as much as the computer can, linked with the number close by). The mix between pause and play makes the simulation step by step, perfect for debugging. And the camera movement? Done in a not so classic (but workable) way using the mouse, you'll get the hang of it :p

##e) Reference material
Now a bit of Lua. There is scope for variables. If you want a variable to work as some global memory of your robot, you need to make it global by defining it at the top of your code (not in a function). You'll see that Lua has only one container type, *tables*, being associative arrays. They store a set of key/value pairs. (Imagine an array that you can access not only with numbers, and if with numbers, not necessarily in a straight order). As mentioned earlier, to (re)discover Lua and understand better this notion of table, you might want to check our [reference page](./ref_lua.html).

If you're curious to know more about the end user possibilities of ARGoS, you can explore them from the command line with `argos3 -q _Something_` (q standing for query). `_Something_` can be either `all` if you want info on everything, or the name of sensors, actuators, type of objects in the arena, name of your favourite restaurant... And then again, you still have the other [reference page](./ref_argos.html).

<!---
##e) Artificial Intelligence
--Will come later--
Entity/function, many many stuff...


##f) Embodiment
--Will come later--
robot (actuator/sensor & brain)


##g) Swarm Robotics
--Will come later--
(local sensing, emphasis on interaction among robots, heterogeneity)

<p>If in a first time you will work on robots taken one by one, you will quickly learn how to create constructive interaction between robots so that won't work each on their own, but collaborate and work as one entity : a swarm.</p>
-->
