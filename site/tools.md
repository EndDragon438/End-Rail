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

Place a mining turtle at the corner of your tunnels start, the top left
corner for a downward mining turtle and the bottom left corner for an
upward mining turtle.

On your mining turtle run:
```
wget 
```

Then, run:

```
run slope.lua <up|down>
```

Be sure to pass `up` or `down` as a parameter to tell the program which
way to dig.