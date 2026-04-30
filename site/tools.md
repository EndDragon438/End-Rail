# Tools

To assist in developing compatible railways, ELR provides several tools
that are useful in designing and building railways. This page describes
these tools and their usage.

## Programs

Programs to be used with computers and turtles.

### Slope

This is a mining turtle program to dig a sloped tunnel at a grade of 12.5%,
the maximum allowed as per the ELR Manual.

Usage:

Place a mining turtle at the top left corner of your tunnels start. Fill
the first slot of the mining turtle with coal or another fuel source.

On your mining turtle run:

```shell
wget https://raw.githubusercontent.com/EndDragon438/End-Rail/refs/heads/main/tools/slope.lua
```

Then, run:

```shell
./slope.lua <up|down>
```

Be sure to pass `up` or `down` as a parameter to tell the program which
way to dig.

The turtle will run until it runs out of fuel or you stop it manually.
The user should monitor the turtle to ensure it runs correctly and is not
interrupted.