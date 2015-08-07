---
layout: default
title:  "Setting up"
num: 0
---

So, before creating [robots discarding collected intel and driving into walls](http://bash.org/?240849), let's setup all the necessary tools and get a bit of context. Both are as necessary: one to do things, the other to understand what you're doing!

##a) ARGoS Simulator
In order to simulate both our robots and their environment, we'll use ARGoS, a multi-physics robot simulator easily customizable by adding new plug-ins. It can efficiently simulate large-scale swarms of robots. Its accuracy aims to be as close as possible to real simulation. It's a tool created with research in mind and used all around the world in laboratories. While we will use it as an educational tool and later as a gaming platform, its constrains & quality are the same than such that would be required by a professional and research environment. In short: whatever you will create here will have real sense. If your behaviour is getting amazing result on a task, be ready to publish about it, yay!

ARGoS takes three things as entry points:
* the robot brain (either C++ code or Lua code);
* an environment code (only in C++), either to update the environment's information (like adding objects) or to add more visuals;
* a .argos (XML) file describing the experimental conditions.

The environment code (loop functions) will be given to you when needed, nothing to worry or care much about. While the .argos files will be given to you too, we will have a look at it together and you might have to change a few parameters along the way (changing the number of robots, the position of places of interest...). The files we provide are meant to be sufficiently commented for you to be able to work it out on your own. Last, and most important: the brain of the robots. This is what we'll be mainly working on in this workshop. While C++ could be used, we will focus on Lua because it makes the whole process easier. If you don't know Lua, don't worry, it's similar to classic programming language.

Two references pages are provided to you (taken from reference material of Carlo Pinciroli's course on Swarm Intelligence) for both [ARGoS](./ref_argos.html) and [Lua](./ref_lua.html). Be sure to come back to them when not sure about what you're doing.

##b) Setting Up ARGoS & Lua
You can either install ARGoS from source or directly from packages. The later should be simpler. Only fall back to the former if you can't make it work, or if you want cutting edge code. Installation can be done on Mac and Linux, alas no possibility for Windows. To install from package, go [there](http://www.argos-sim.info/core.php); to install from source, check [here](https://github.com/ilpincy/argos3/)  

In order to check if ARGoS is well installed, just type `argos3 --version`, a green text should appear with the version name of currently installed ARGoS.

##c) Your first code
Let's release the beast. In order to launch ARGoS, you need to write in the command line `argos3 -c _expSetup_` where `_expSetup_` is your experimental setup file (the .argos file) and the c in the `-c` flag stands for configuration. [Here](./assets/code/test.argos) is the test file we'll be using in this section and [here](./assets/code/one_spot.png) is the accompagned picture for the floor. Download both files, and type `argos3 -c setup.argos` where you put them.

You should see two new windows appearing. One is a text editor (where you will type your Lua code and execute it), the other one is the ARGoS simulator itself.

You will find in the simulator a view of your arena on the centre, two text area for logging purposes on the right, and some control on the top (play, stop, step by step, forward, reset, screen-shot, camera options...). Play launches the simulation, other buttons behave as expected in such context.

In the Lua code editor, you will find that there is some functions defined, characterising a code structure. As already well explained in the comments, they are:

* **init** called once at the creation of the robots
* **step** called at each step of the experiment
* **reset** called when the reset button is pressed
* **destroy** called at the end of the experiment

Let's launch our first experimentation to better understand what's happening. On top of all the power of Lua, ARGoS provide you with a specific container, adequately called `robot`. Anything robot related (sensor & actuator) will go through it. Type inside the step function the following line :

```Lua
log("Hello, my name is " .. robot.id)
```

where log is an ARGoS specific function, re-routing to the logging text areas that we mentioned earlier, and robot.id refers to the robot own identification number.

Apart from the classic text editor functionality, you'll see on the right end a little gear icon. Click on it (or press **Ctrl-E**) to execute your code. Once done, the code is loaded in the ARGoS simulator, you can just press play and see its wonder. Which isn't much (yes, the robot can move, they are just sleepy right now). On the right side, you'll see time steps and logging information. The simulation of the world here is executed steps by steps. At each steps (or ticks), the function `step` is called for each robots, and is resolved.

##d) Reference material
Now a bit of Lua. There is scope for variables. If you want a variable to work as some global memory of your robot, you need to make it global by defining it at the top of your code (not in a function). You'll see that Lua has only one container type, *tables*, being associative arrays. They store a set of key/value pairs. (Imagine an array that you can access not only with numbers, and if with numbers, not necessarily in a straight order). When lost, you can refer to [this page](http://iridia.ulb.ac.be/~cpinciroli/extra/h-414/#programming_robots_lua) for a basics of how Lua handle classic stuff (loops, if then, etc. etc.) and a deeper understanding of tables.

[Lower on the same page](http://iridia.ulb.ac.be/~cpinciroli/extra/h-414/#programming_robots_robot), you will find a list of what the robot can do, and how to make it work with Lua. Last, you can use the help from the command line, by typing `argos3 -q _Something_` (q for query). `_Something_` can be either `all` if you want info on everything, or the name of sensors, actuators, type of objects in the arena...

While you might not have to use any of both, those two places will be of great help if you get lost or want to wonder out of beaten tracks.


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
