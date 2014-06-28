debian2docker
-------------

### What is debian2docker?

This is a fork of the "official" debian2docker found here:

[https://github.com/unclejack/debian2docker](https://github.com/unclejack/debian2docker)

>
Debian2docker is a hybrid bootable ISO which starts an amd64 Linux system based on Debian. Its main purpose is to run Docker and to allow the execution of containers using Docker.

### Dependencies

The only dependency is that Docker needs to be available on the build machine.

### How to build

Simply run the `build.sh` script. The ISO is build inside of a Docker container and the result is copied out into this folder.

### How to run

Burn the ISO to a disk or load it into a virtual machine. It will boot to a bash prompt with Docker installed.

Some other features are not implemented yet.

### How to install

This feature is not available yet.

### Why the fork?

I had stumbled upon some interesting Docker projects:

 - [Boot to Docker](https://github.com/unclejack/debian2docker)
 - [Docker Desktop](https://github.com/rogaha/docker-desktop)
 - [Docker in Docker](https://github.com/jpetazzo/dind)
 
It occurred to me, can we run Docker as a main OS? We have all the pieces to do so.  
I decided to start from debian2desktop as this will be the underlying core that runs the system.

### Docker as an OS

When I talk about Docker as an OS, I am intending it to be for a single desktop user, such as a developer like myself. This is not intended to be used for a scalable production environment, if you are looking for that check out [CoreOS](https://coreos.com/). Rather, I am trying to create a flexible, portable OS that has all the best features of Debian and Docker together.

In doing so, I have some goals I am hoping to achieve:

 - A live system that allows for encrypted persistence.
 - Easy to rebuild, modify, and customize.
 - Each application sandboxed for security.
 - Allow "restore factory defaults" at any time.

### How does it work?

The idea is that when the base image is booted, it starts an X server and a docker container, either from the ISO or on a USB stick. The "host" running the X server will then connect to the docker container with X forwarding to allow the container to display a GUI. The container that is run will be a docker-desktop instance, but it could just as easily be a web browser or something else entirely.

To the user, they will just see their desktop come up as usual, but behind the scenes that desktop is completely sandboxed from the base system, and has the layering advantages of a docker container.
The host is able to run multiple desktop instances, meaning they can switch workflows very easily.
Finally, if docker-in-docker is used inside the docker-desktop image, then additional sandboxed applications can be run inside each desktop.

Your desktop environment can be completely reconfigured at run time. It is like building a system out of Lego bricks, where a Docker container is a brick.

### Possible uses

 - Convert any application into its own bootable live cd
 - Run a Firefox browser in kiosk mode
 - Turn any machine into a thin client
 - ...or a server

### Requirements

Some of the requirements I have set are:

 - The core image should fit on a business card sized CD (~50MB).
 - Only contain the necessary packages, nothing extraneous preinstalled. 
 - Support an auto-image import functionality to allow Docker containers to be preloaded
 - Perform a "frugal" installation with encrypted persistence
 - Support a customized non-standard kernel, such as one from Kali linux
 - Utilize the iso-hybrid format to allow burning to disk or dd'ing to usb.
 - Keep it easy to boot anywhere; Rootfs inside of the initramfs
 