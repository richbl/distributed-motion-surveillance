# Distributed-Motion-Surveillance (DMS)

**Distributed-Motion-Surveillance (DMS)** is a Ruby-based video surveillance system using the [Motion](https://motion-project.github.io/) motion detection software package to identify and respond to significant image capture changes in video camera streams. **DMS** differs from other video surveillance systems in that all video camera endpoints are "smart" devices capable of processing raw video streams on-board, rather than requiring a single centralized device to process all streams remotely. This approach greatly reduces network traffic during surveillance event activities, and evenly re-distributes video stream processing to participating endpoints.

**DMS** uses a [client server model](https://en.wikipedia.org/wiki/Client%E2%80%93server_model) as its network architecture, where the server component is centrally responsible for the logic of enabling/disabling the video surveillance system, while each client endpoint participating in the system performs the real-time video monitoring, processing of video stream data, and notification and/or delivery of processed results based on local configuration policies.

In the image below, three IOT devices (*e.g*., Raspberry Pis) are managed through a central server (using the [TCP protocol](https://en.wikipedia.org/wiki/Transmission_Control_Protocol)), which synchronizes [Motion](https://motion-project.github.io/) capture state across all clients. **Importantly, actual [Motion](https://motion-project.github.io/) video stream processing is done only on the clients.**

![topology_diagram](https://cloud.githubusercontent.com/assets/10182110/24839972/187aec3e-1d19-11e7-99ef-e92e0e4e55bc.png)

**DMS** is organized into the following package components:

   - **DMSServer**: integrated server-side system services that determine when to start/stop the [Motion](https://motion-project.github.io/) package, and regularly notify participating clients of that surveillance state.
   - **DMSClient**: client-side services that start/stop the [Motion](https://motion-project.github.io/) package (and related video stream processing) based on notifications from DMSServer
   - **DMSMail**: a configurable component for generating and sending an email with images whenever a client running [Motion](https://motion-project.github.io/) generates a significant motion-related event
   - **Libs**: a set of related shared libraries used for managing **DMS** client-server services including low-level system and networking commands, logging, and unit testing


## DMS Features

 - [Motion](https://motion-project.github.io/) Software Package

	- Movement detection support of video cameras. See [this list](http://www.lavrsen.dk/foswiki/bin/view/Motion/WorkingDevices "Device Compatibility") for video device compatibility. Note that **DMS** was developed and tested using smart devices running [Motion](https://motion-project.github.io/) locally, with native camera support (*e.g.*, a Rasperry Pi with an on-board camera module installed and configured).
 - DMSClient/DMSServer Components
	 - Automated enabling/disabling of the [Motion](https://motion-project.github.io/) detection software program based on the presence/absence of Internet of Things ([IoT](http://en.wikipedia.org/wiki/Internet_of_Things "Internet of Things")) devices across a network (*e.g.*, [LAN](http://en.wikipedia.org/wiki/Local_area_network "Local Area Network")).

		 - [MAC](http://en.wikipedia.org/wiki/MAC_address "MAC address") address sensing
			 - Multiple [IoT](http://en.wikipedia.org/wiki/Internet_of_Things "Internet of Things") device support
			 - IPv4 protocol support
			 - IPv6 protocol support [planned]
		 - 'Always On' feature starts/stops the [Motion](https://motion-project.github.io/) program based on time-of-day (*e.g*., enable video surveillance during nighttime and/or holiday hours)
		 - Optionally play an audio file on surveillance system enable/disable
		 - Event logging
		 - Bluetooth sensing (RSSI) [planned]
	 - Device clients can be custom-configured to process and respond to event data independently
		 - With [Motion](https://motion-project.github.io/)  running independently on every **DMS** device, each device can react in ways unique to that device (*e.g.,* an outdoor IR camera only sending email during nighttime hours)

 - DMSMail Component

	 - Automated, real-time email notification on [Motion](https://motion-project.github.io/) detection events

		 - Configurable message body
		 - Optionally attach event image or video in message
		 - SMTP-support for compatibility with most webmail services (*e.g.*, [Gmail](http://gmail.com "Google Gmail"))
		 - Event logging
		 - POP3-support [planned]

## How DMS Works


### DMSServer Operation
DMSServer is centrally responsible for the *logic of enabling/disabling the video surveillance system* (determining when to start/stop the [Motion](https://motion-project.github.io/) software package on each client endpoint).

It does this by periodically scanning the network for the existence of a monitored device(s). This device can be anything that exposes its MAC address on the network (*e.g.*, a mobile phone on a home LAN). In the default case, if that device is found on the network, it's assumed that "someone is home" and so, [Motion](https://motion-project.github.io/) is not started (or is stopped if currently running). If that device MAC leaves and is no longer found on the network, it's assumed that "nobody is home" and [Motion](https://motion-project.github.io/) is started (if not already running). Similar logic is used in the reverse case: when a monitored device is once again "back home," [Motion](https://motion-project.github.io/) is stopped.

Alternatively, the optional 'Always On' feature, if enabled, uses time-of-day to start/stop the [Motion](https://motion-project.github.io/) software package. DMSServer will look at the time range specified, and if the current time falls between the time range, [Motion](https://motion-project.github.io/) will be activated. Once the current time falls outside of the specified time range, [Motion](https://motion-project.github.io/) is then stopped. The 'Always On' feature works in conjunction with standard IoT device detection.

> **Note**: DMSServer only signals to DMS clients (through each DMSClient component) the current state of the video surveillance system. Each client is technically responsible for actually starting/stopping its locally-installed instance of the [Motion](https://motion-project.github.io/) software package.

### DMSClient Operation
DMSClient runs on each client endpoint, and is responsible *physically starting/stopping its native video camera capture* (starting/stopping its locally-installled instance of the [Motion](https://motion-project.github.io/) software package).

It does this by periodically listening to the DMSServer server at the pre-configured [IP address](https://en.wikipedia.org/wiki/IP_address) and [port](https://en.wikipedia.org/wiki/Computer_port_%28hardware%29) (network [socket address](https://en.wikipedia.org/wiki/Network_socket)). DMSServer, using its own logic (see above section), will pass to all connected clients its *motion state*, that is, whether to ask clients to enable/disable their installed instance of the  [Motion](https://motion-project.github.io/) software package.

Based on this locally-installed instance of [Motion](https://motion-project.github.io/), a **DMS** client can respond to significant image capture events in a unique and customized manner.

> For additional details on how to customize the  [Motion](https://motion-project.github.io/) software package, refer to the [Motion documentation](https://htmlpreview.github.io/?https://github.com/Motion-Project/motion/blob/master/motion_guide.html)

### DMSServer/DMSClient Work Flow
Operationally, DMSServer and the various DMSClient component instances work in concert to establish a synchronized video surveillance state across all endpoints:

- **DMS-Server**: a daemon that runs on the central server, and walks a logic tree whenever a client connects (or re-connects) to the server. DMS-Server is responsible for answering the question "should the video surveillance system be enabled or disabled?"
- **DMS-Client**: a daemon that runs on each of the participating smart devices. DMS-Client regularly polls (at a configurable interval) DMS-Server, and receives from DMS-Server the current *motion state*, that is, whether the local instance of [Motion](https://motion-project.github.io/) should be started/stopped

The activity diagram below shows the work flow of these two components:

![distributed_motion_surveillance_activity_diagram](https://cloud.githubusercontent.com/assets/10182110/24991050/1199870c-1fcd-11e7-9bd0-2dda4d42d3b4.png)

### DMSMail Operation

One specific (optional) DMSClient response created for **DMS** is the creation and sending of an email whenever a valid image capture event is triggered in [Motion](https://motion-project.github.io/). This **DMS** component is called DMSMail.

DMSMail is very tightly integrated into [Motion](https://motion-project.github.io/), where image capture events are identified and processed. These events are triggered through the  [`on_picture_save`](http://www.lavrsen.dk/foswiki/bin/view/Motion/ConfigOptionOnPictureSave "on_picture_save command") command and the [`on_movie_end`](http://www.lavrsen.dk/foswiki/bin/view/Motion/ConfigOptionOnMovieEnd "on_movie_end command") command in [Motion](https://motion-project.github.io/) and are how the DMSMail component gets called.

The syntax for these [Motion](https://motion-project.github.io/) commands are:

	<on_picture_save|on_movie_end> <absolute path to ruby> <absolute path to mail.rb> <%D %f %t>

These commands are managed through the [Motion](https://motion-project.github.io/) configuration file called `motion.conf`.

Once configured, DMSMail will respond to these [Motion](https://motion-project.github.io/) event [hooks](http://en.wikipedia.org/wiki/Hooking "Hooking"), and an email will be generated and sent along with an optional image file or video clip.

> **Note:** additional information about the DMSMail component can be found in the **DMS** installation file ([`INSTALL.md`](https://github.com/richbl/Distributed-Motion-Surveillance/blob/master/INSTALL.md "INSTALL.md")).

## DMS Requirements

 - A Linux-based operating system installed on the server and client endpoints
	 - While **DMS** was written and tested under Linux (Ubuntu 16.10), there should be no reason why this won't work under other Linux distributions
 - Specific Unix-like tools used by **DMS** include:
	 - [ps](http://en.wikipedia.org/wiki/Ps_%28Unix%29): process status
	 - [arp](http://en.wikipedia.org/wiki/Address_Resolution_Protocol): address resolution protocol
	 - [grep](http://en.wikipedia.org/wiki/Grep): globally search a regular expression and print
	 - [ping](http://en.wikipedia.org/wiki/Ping_(networking_utility)): ICMP network packet echo/response tool
	 - [aplay](http://en.wikipedia.org/wiki/Aplay): ALSA audio player (optional)
 - [Motion](https://motion-project.github.io/) correctly installed and configured with appropriate video devices on each client enpoint
 - [Ruby](https://www.ruby-lang.org/en/ "Ruby") (2.0+) correctly installed and configured on the server and each client endpoint
	 - [Rubygems](https://rubygems.org/ "Rubygems") installed and configured with the following gems:
		 - [mail](https://rubygems.org/gems/mail) (2.5.4+)
		 - [thread](https://rubygems.org/gems/thread) (0.1.4+)

## DMS Installation
For complete details on **DMS** installation, see the installation file ([`INSTALL.md`](https://github.com/richbl/Distributed-Motion-Surveillance/blob/master/INSTALL.md "INSTALL.md")).

## License

The MIT License (MIT)

Copyright (c) Business Learning Incorporated

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
