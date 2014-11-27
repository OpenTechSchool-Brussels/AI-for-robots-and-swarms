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
* Install the package. Open a terminal where you downloaded the pakage and type: `dpgk -i _FileName_` where `_FileName_` is indeed the name of the package you just downloaded.

On Mac:
* Using Brew as can be read [here](http://bohr.ulb.ac.be/~pincy/argos/core.php).

In order to check if ARGoS is well installed, just type `argos3 --version`, a green text should appearing with the version name of currently installed ARGoS.

##b) ARGoS Simulator
ARGoS is a multi-physics robot simulator easily customizable by adding new plug-ins. It can simulate large-scale swarms of robots of any kind efficiently. Its accuracy aims to be as close as possible to real simulation, making it the perfect first step before porting your code on real robot.

ARGoS don't work on its own, you need to feed him 3 stuff:
* The robot brain (either C++ code or, as in our case, Lua code);
* An environment code (only in C++), either to update the world information or to add more visuals; 
* and last, a .argos (XML) file describing the experimental setup.

The environment code (loop functions) will be given to you when needed, nothing to worry or care much about. While the .argos files will be given to you too, we will refer to it sometimes and you might even want on your own to make a few modifications to the experimental setup (changing the number of robots in the arena, the position of places of interest, etc. etc. ). We hope the files we provide are sufficiently commented for you to be able to work it out on your own. Last, and most important: the brain of the robots. This is what we'll be mainly working on in this workshop.


##c) Your first code
Let's release the beast. In order to launch ARGoS, you need to write in the command line `argos3 -c _expSetup_` where `_expSetup_` is your experimental setup file (the .argos file) and the c in the `-c` flag stands for configuration. [Here]() is the test file we'll be using in this section. Download the file, and type `argos3 -c setup.argos` where you put it.

You should see two new windows appearing. One is a text editor (where you will type your Lua code and compile it), the other one is the ARGoS simulator itself. In the later, you have a view of your arena, two text area for logging purposes, and some control on the top (play, stop, step by step, forward, camera options).


Lua code stuff.

Basic functions when you arrive
Notion of "ticks" for execution

Base of Lua (scope variable, table & copy table, ref page.

robot table (don't feed it straight). Logging of id

##d) Reference material

##e) Artificial Intelligence
Entity/function, many many stuff...


##f) Embodiment
robot (actuator/sensor & brain)


##g) Swarm Robotics
(local sensing, emphasis on interaction among robots, heterogeneity)
