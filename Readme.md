# IxN Grapher
IxN Grapher is a container that generates graphs from IxN traffic flow statistics. It will parse all csv files found within it's input directory, puts the resultant png files in it's output directory and then exit.

# Requirements
That you have docker installed. To understand how to install Docker for your system please refer to the [Docker website](https://www.docker.com).

# How to Install/Start
IxN Grapher is on Docker Hub. Provider docker is installed all you need to do is run `docker run -v <input dir>:/usr/app/input -v <output dir>:/usr/app/output ixn-grapher`. Here is an actual example:

```bash
$ docker run -v $PWD/input:/usr/app/input -v $PWD/output:/usr/app/output ixn-grapher
```

This will download, if not already present on your system, and then run the container.

The container will then parse all the flow statistic csv files in the input dir and place resultant png files in the output dir.

# Command Line Arguments
IxN Grapher requires two command line arguments to function. Both arguments defne a mount point between the host and the container. The order is not important.

IxN Grapher expects /usr/app/input (within the container) to contain subdirectories that contain csv files. This aligns with IxNetwork's behaviour for creating flow statistics csv files.

IxN Grapher uses the subdirectory name to generate the png file name. These png files are placed in /usr/app/output by IxN Grapher.

# Supported Traffic Types
IxN Grapher will generate a png file for either unicast and multicast traffic (if provided). By default IxN Grapher assumes the traffic is unicast. If the Traffic Item contains the word "multicast" (case insensitive) then it will treat this traffic as multicast.