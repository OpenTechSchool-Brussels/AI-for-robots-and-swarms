---
layout: default
title:  "ARGoS Installation Tutorial"
---

*Installation of ARGoS on Linux and Mac is straight forward, please refer to [argos-sim.info/user_manual.php](http://www.argos-sim.info/user_manual.php) to install ARGoS. Please be sure to reach us if there are any issues.*

In this tutorial, we will show you how to install ARGoS on a Windows 11 machine. ARGoS is only native on Mac and specific flavors of Linux, so we will first need to install WSL (Windows Subsystem for Linux) that allows you to run any program that runs on Linux. Then, we will install ARGoS as if we were on Linux, and finish by making some modifications with libraries in order for ARGoS to reach them. You need to have administrative privilege on this machine, or at least to have high enough clearance to be able to install software on it. If you’re not sure, please check with your IT department or give the tutorial a go!

The whole process takes less than half an hour, most of it spent waiting for downloads to finish. It is important that you come with ARGoS installed so we can make the best of the time spent together during the workshop. If you have any issues (or even just questions) during the installation process, be sure to reach me at roman.miletitch@mpi.nl. We will do our best to help you!


<h2>Step by step</h2>
The first step is to install WSL. For that you need to open the Power Shell (the command line of Windows). To do so, open your start menu (either by pressing on the Windows key of your keyboard, or by clicking on the start/window button in your task bar). Then, in the search text area, enter **PowerShell**, and then click on the associated program that should appear in the list.

In the **PowerShell**, type the following command and run it (press enter) in order to install WSL:

```bash
wsl --install
```
This should take between 2 and 5 minutes depending on your connection.

You might be asked to reboot your system. Do so, and then open again the **PowerShell**, and run the following command:
```bash
wsl
```

You might see a message telling you that no distribution is installed, such as "Windows Subsystem for Linux has no installed distributtions". If so, then run the following command, installing Ubuntu 24.04:
```bash
wsl --install Ubuntu-24.04
```

A Help window will then appear, you are free to roam around or just close it. In the command line, you are then asked to enter an account name, and a password. Please remember both! Password input in Linux doesn't show any characters (not even *), which is always a bit stressful at first!

Now is time to run an update on your system, to be sure that your software repository have all the latest versions:
```bash
sudo apt update && sudo apt upgrade
```

Run the next command to download ARGoS, a configuration file, and a floor image:
```bash
wget 'https://github.com/OpenTechSchool-Brussels/AI-for-robots-and-swarms/raw/refs/heads/gh-pages/assets/argos3_b59.deb'
wget 'https://github.com/OpenTechSchool-Brussels/AI-for-robots-and-swarms/raw/refs/heads/gh-pages/assets/configTest.argos'
wget 'https://github.com/OpenTechSchool-Brussels/AI-for-robots-and-swarms/raw/refs/heads/gh-pages/assets/floor.png'
```

And this one to install it (press Y and then enter when asked to do so):
```bash
sudo apt install ./argos3_b39.deb
``` 
You can now test out ARGoS with the following command:
```bash
argos3 -c configTest.argos
```

Here, **argos3** is the name of the software, **-c** is what is called a flag, here meaning you will feed it a configuration file, and **configTest.argos** is the configuration file of the experiment we want to run here)

You should see two windows appearing. One with an arena, a painted floor and robots (where you are meant to run the experiment); and another one with a text editor (where you are meant to code the behavior of the robots).
If you see both things, congrats, you’re ready for the workshop! You can explore on the left the current version of the tutorial (update coming begining Nov 2025), in order to understand a bit better how to code the robot, and have a bit of experience. This will be very welcomed for the workshop, as you will be able to focus on the linguistic aspect of the behavior.



<h2>Troubleshooting</h2>
If when trying to run ARGoS you see a red error message, please run the following commands, one by one:

```bash
sudo ln -s /usr/lib/x86_64-linux-gnu/libglut.so.3.12.0 /usr/lib/x86_64-linux-gnu/libglut.so.3
sudo ln -s /usr/lib/x86_64-linux-gnu/libglut.so.3 /usr/lib/
sudo ldconfig
```

And run again ARGoS with the same command above.

If you see any other error messages, or if the previous one is still not resolved with those added commands, please do reach us, we will do our best to help you and update this tutorial incorporating your case issue. Thanks for helping us making this short tutorial better!






