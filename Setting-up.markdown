---
layout: default
title:  "Setting up"
num: 0

---

All right! We're doing it :D Let's take care of the installation process so we can start messing with the robots! After making sure everything is working fine, a few paragraphs will give you a bit of context.

##a) Setting Up ARGoS & Lua
First of all, we need to install our environment. Since ARGoS depends on Lua, installing the former will install the later.

**On Linux**

* Download the package [here](http://bohr.ulb.ac.be/~pincy/argos/core.php).
* To install the package, open a terminal where you downloaded the pakage and type: `dpgk -i _FileName_` where `_FileName_` is indeed the name of the package you just downloaded.

**On Mac**

* Using Brew as can be read [here](http://bohr.ulb.ac.be/~pincy/argos/core.php).

In order to check if ARGoS is well installed, just type `argos3 --version`, a green text should appear with the version name of currently installed ARGoS.

##b) ARGoS Simulator
ARGoS is a multi-physics robot simulator easily customizable by adding new plug-ins. It can simulate large-scale swarms of robots of any kind efficiently. Its accuracy aims to be as close as possible to real simulation, making it the perfect first step before porting your code on real robot.

ARGoS doesn't work on its own, you need to feed him 3 stuff:

* The robot brain (either C++ code or, as in our case, Lua code);
* An environment code (only in C++), either to update the world information or to add more visuals; 
* and last, a .argos (XML) file describing the experimental setup.

The environment code (loop functions) will be given to you when needed, nothing to worry or care much about. While the .argos files will be given to you too, we will refer to it sometimes and you might even want on your own to make a few modifications to the experimental setup (changing the number of robots in the arena, the position of places of interest, etc. etc. ). We hope the files we provide are sufficiently commented for you to be able to work it out on your own. Last, and most important: the brain of the robots. This is what we'll be mainly working on in this workshop.


##c) Your first code
Let's release the beast. In order to launch ARGoS, you need to write in the command line `argos3 -c _expSetup_` where `_expSetup_` is your experimental setup file (the .argos file) and the c in the `-c` flag stands for configuration. [Here]() is the test file we'll be using in this section. Download the file, and type `argos3 -c setup.argos` where you put it.

You should see two new windows appearing. One is a text editor (where you will type your Lua code and execute it), the other one is the ARGoS simulator itself.

You will find in the simulator a view of your arena on the centre, two text area for logging purposes on the right, and some control on the top (play, stop, step by step, forward, reset, screen-shot, camera options...). Play launches the simulation, other buttons behave as expected in such context.

In the Lua code editor, you will find that there is some functions defined, characterising a code structure. As already well explained in the comments, they are :
* **init** : launch once at the creation of the robots
* **step** : launch at each step of the experiment
* **reset** : launch when the reset button is pressed
* **destroy** : launch at the end of the experiment

In a first step, you won't have to deal with **reset** & **destroy** (a nice name for a heavy metal band).

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
Entity/function, many many stuff...


##f) Embodiment
robot (actuator/sensor & brain)


##g) Swarm Robotics
(local sensing, emphasis on interaction among robots, heterogeneity)
