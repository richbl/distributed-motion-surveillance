## Distributed-Motion-Surveillance (DMS) Installation
**Distributed-Motion-Surveillance (DMS)** is a Ruby-based video surveillance system using the [Motion](https://motion-project.github.io/) motion detection software package to identify and respond to significant image capture changes in video camera streams.

The installation of **DMS** includes:

 1. The installation and configuration of the [Motion](https://motion-project.github.io/) software program (required on client devices only)
 2. The installation and configuration of **DMS** components which include:
 
   - **MotionServer**: required, installed on the server
   - **MotionClient**: required, installed on client device(s)
   - **MotionMail**: optional, installed on client device(s)
   - **Lib**: required, installed on server and client device(s)
> For details on **DMS** components, see the project introduction ([`README.md`](https://github.com/richbl/distributed-motion-surveillance/blob/master/README.md))

 3. The integration of **DMS** Components with [Motion](https://motion-project.github.io/)

### 1. Confirm That All DMS Requirements are Met Before Proceeding

1. Review **DMS** requirements section in the [`README.md`](https://github.com/richbl/distributed-motion-surveillance/blob/master/README.md)
 
	To summarize these requirements: the operating system is Unix-like (*e.g.*, Linux); the [Motion](https://motion-project.github.io/) software program should be installed on all device clients; the Ruby language, and all required Ruby gems should be installed and fully operational.

### 2. Confirm the Installation and Configuration of the [Motion](https://motion-project.github.io/) Software Program

 1. Confirm the installation of the [Motion](https://motion-project.github.io/) software program package **on all device clients** (*e.g.*, Raspberry Pi).

	Before installing **DMS**, the [Motion](https://motion-project.github.io/) software program should to be correctly installed, configured and operational on all participating device clients. Details for [Motion](https://motion-project.github.io/) installation can be found on the [Motion website](https://htmlpreview.github.io/?https://github.com/Motion-Project/motion/blob/master/motion_guide.html).
 
 2. Configure [Motion](https://motion-project.github.io/) to run as a daemon.

	For proper operation with **DMS**, [Motion](https://motion-project.github.io/) should be set to run in daemon mode (which permits [Motion](https://motion-project.github.io/) to run as a background process). This is achieved through an edit made to the `motion.conf` file located in the [Motion](https://motion-project.github.io/) folder (*e.g.,* `/etc/motion`).

	In the section called Daemon, set the `daemon` variable to `on` as noted below:

	    ############################################################
	    # Daemon
	    ############################################################
	    
	    # Start in daemon (background) mode and release terminal (default: off)
	    daemon on

### 3. Download and Install the DMS Package
#### Server Installation
The server component of **DMS**, MotionServer, is centrally responsible for the logic of enabling/disabling the video surveillance system (determining when to start/stop the [Motion](https://motion-project.github.io/)  software package on each client endpoint). Note, however, that MotionServer does not have any direct dependencies on the [Motion](https://motion-project.github.io/) sofware program.

 1. Download the repository zip file from the [DMS repository](https://github.com/richbl/distributed-motion-surveillance) and unzip into a temporary folder.

 3. Optionally, delete non-essential top-level files, as well as the `motion_client`, and `motion_mail` components (as these components are unused on the server), but preserve these component folders: `lib` and `motion_server`.

	> The top-level informational files (*e.g.*, `README.MD`, `INSTALL.MD`, *etc.*) are not required to properly configure and run **DMS**. They may be safely deleted.

	The organization of the server components is represented in the remaining structure of the parent `distributed-motion-surveillance` folder. 

	> 	**Note:** the location of this folder structure is not important, but the relative folder structure and names must be preserved

 2. Copy the remaining `distributed-motion-surveillance` folder structure into an appropriate local folder.

	As an example, since the [Motion](https://motion-project.github.io/) software program installs into the `/etc` folder (as `/etc/motion`) on a Debian-based system, **DMS** can also be installed into the `/etc` folder.

	The folder tree below represents the complete project for the server (after non-essential top-level files and components have been removed):

	```
	distributed-motion-surveillance/
	├── lib
	│   ├── lib_audio.rb
	│   ├── lib_config.rb
	│   ├── lib_log.rb
	│   ├── lib_mail.rb
	│   ├── lib_motion.rb
	│   ├── lib_network.rb
	│   └── tests
	│       ├── lib_audio_test.rb
	│       ├── lib_config_test.rb
	│       ├── lib_log_test.rb
	│       ├── lib_motion_test.rb
	│       ├── lib_network_test.rb
	│       └── libs_test.rb
	└── motion_server
	    ├── media
	    │   ├── motion_start.wav
	    │   └── motion_stop.wav
	    ├── server_config.rb
	    ├── server_connector.rb
	    ├── server_daemon.rb
	    ├── server_logging.rb
	    ├── server_manager.rb
	    └── server_start.rb
	```

#### Client Installation
The distributed client component of **DMS**, MotionClient, runs on each client endpoint, and is responsible physically starting/stopping its native video camera capture (starting/stopping its locally-installed instance of the [Motion](https://motion-project.github.io/) software package).

  1. Download the repository zip file from the [DMS repository](https://github.com/richbl/distributed-motion-surveillance) and unzip into a temporary folder.

 3. Optionally, delete non-essential top-level files, as well as the `motion_server` component (as this component is unused on the client), but preserve these component folders: `lib`, `motion_mail`, and `motion_client`.

	> The top-level informational files (*e.g.*, `README.MD`, `INSTALL.MD`, *etc.*) are not required to properly configure and run **DMS**. They may be safely deleted.

	The organization of the client components is represented in the remaining structure of the parent `distributed-motion-surveillance` folder. 

	> 	**Note:** the location of this folder structure is not important, but the relative folder structure and names must be preserved

 2. Copy the remaining `distributed-motion-surveillance` folder structure into an appropriate local folder.

	As an example, since the [Motion](https://motion-project.github.io/) software program installs into the `/etc` folder (as `/etc/motion`) on a Debian-based system, **DMS** can also be installed into the `/etc` folder.

	The folder tree below represents the complete project for the server (after non-essential top-level files and components have been removed):

	```
	distributed-motion-surveillance/
	├── lib
	│   ├── lib_audio.rb
	│   ├── lib_config.rb
	│   ├── lib_log.rb
	│   ├── lib_mail.rb
	│   ├── lib_motion.rb
	│   ├── lib_network.rb
	│   └── tests
	│       ├── lib_audio_test.rb
	│       ├── lib_config_test.rb
	│       ├── lib_log_test.rb
	│       ├── lib_motion_test.rb
	│       ├── lib_network_test.rb
	│       └── libs_test.rb
	├── motion_client
	│   ├── client_config.rb
	│   ├── client_connector.rb
	│   ├── client_daemon.rb
	│   ├── client_logging.rb
	│   ├── client_manager.rb
	│   └── client_start.rb
	└── motion_mail
	        ├── mail_config.rb
		├── mail_logging.rb
	        └── mail.rb
	```

### 4. Configure DMS Package Components
#### Server Configuration

1. Edit **DMS** `*_config.rb` configuration files.

	All server-side package components--MotionServer and Lib--should be configured for proper operation. Each component includes a separate `*_config.rb` file which serves the purpose of isolating user-configurable parameters from the rest of the code:
	
	- 	`server_config.rb`, found in the `distributed_motion_surveillance/motion_server` folder, is used for:
		- setting the server port
		- determining what devices to monitor (MAC addresses)
		- determining when to run the Always On feature (set time range)
		- identifying audio files used when enabling/disabling the surveillance system
		- configuring component logging options
	- `lib_config.rb`, found in the `distributed_motion_surveillance/lib` folder, is used to configure the location of system-level commands (*e.g.*, /bin/ping). In general, these settings are OS-specific, and should not need to be changed when running on a Debian-based system

	Each configuration file is self-documenting, and provides examples of common default values.

2. Optional: configure server to run the MotionServer daemon at startup.

	As different Unix-like systems use different approaches for system service management and startup, this step is beyond the scope of the install procedure. However, depending on the operating system (*e.g.*, Ubuntu 16.10, which relies on [`systemd`](https://en.wikipedia.org/wiki/Systemd)), the **DMS** MotionServer file to run at startup is `server_daemon.rb`, located in  the `distributed_motion_surveillance/motion_server` folder.

#### Client Configuration

1. Edit **DMS** `*_config.rb` configuration files.

	All client-side package components--MotionClient, MotionMail, and Lib--should be configured for proper operation. Each component includes a separate `*_config.rb` file which serves the purpose of isolating user-configurable parameters from the rest of the code:
	
- 	`client_config.rb`, found in the `distributed_motion_surveillance/motion_client` folder, is used for:
		- setting the server IP address and port
		- setting the frequency to check to server for changes to motion state
		- configuring component logging options
- 	`mail_config.rb`, found in the `distributed_motion_surveillance/motion_mail` folder, is used for:
		- setting email configuration options
		- configuring component logging options
- `lib_config.rb`, found in the `distributed_motion_surveillance/lib` folder, is used to configure the location of system-level commands (*e.g.*, /bin/ping). In general, these settings are OS-specific, and should not need to be changed when running on a Debian-based system

	Each configuration file is self-documenting, and provides examples of common default values.

2. Optional: configure client device to run the MotionClient daemon at startup.

	As different Unix-like systems use different approaches for system service management and startup, this step is beyond the scope of the install procedure. However, depending on the operating system (*e.g.*, Ubuntu 16.10, which relies on [`systemd`](https://en.wikipedia.org/wiki/Systemd)), the **DMS** MotionClient file to run at startup is `client_daemon.rb`, located in  the `distributed_motion_surveillance/motion_client` folder.

### 5. Optional: Integrate MotionMail with [Motion](https://motion-project.github.io/) on the Device Client

MotionMail is the **DMS** client-side component responsible for sending an email whenever a valid movement event is triggered in [Motion](https://motion-project.github.io/). These events are triggered through the [*on_picture_save* command ](http://www.lavrsen.dk/foswiki/bin/view/Motion/ConfigOptionOnPictureSave "on_picture_save command") and the [on_movie_end command](http://www.lavrsen.dk/foswiki/bin/view/Motion/ConfigOptionOnMovieEnd "on_movie_end command") in [Motion](https://motion-project.github.io/) and are how MotionMail gets called. 

The syntax for these [Motion](https://motion-project.github.io/) commands are:
  
	<on_picture_save|on_movie_end> <absolute path to ruby> <absolute path to mail.rb> <%D %f %t>

These commands are saved in the [Motion](https://motion-project.github.io/) configuration file called `motion.conf` (located in `/etc/motion`).

> **Note:** the parameters passed on this command (<%D %f %t>) are called *conversion specifiers* and are described in detail in the [Motion](https://motion-project.github.io/) documentation on [ConversionSpecifiers](http://www.lavrsen.dk/foswiki/bin/view/Motion/ConversionSpecifiers "ConversionSpecifiers").

1. Update the [Motion](https://motion-project.github.io/) `motion.conf` file to call MotionMail on picture save (or movie end).

	The easiest way to edit this file is to append the `on_picture_save` or `on_movie_end` command at the end of the `motion.conf` file. For example:

		$ echo 'on_picture_save /usr/bin/ruby /etc/**DMS**/motion_mail/mail.rb %D %f %t' >> /etc/motion/motion.conf

2. Restart [Motion](https://motion-project.github.io/) to have the update to `motion.conf` take effect. 

		$ sudo /etc/init.d/motion restart
		
	or if running with [`systemd`](https://en.wikipedia.org/wiki/Systemd)

		$ sudo service motion restart
		
MotionMail will now generate and send an email whenever [Motion](https://motion-project.github.io/) generates an `on_picture_save` or `on_movie_end` command.

### 7. Configuration Testing & Troubleshooting

At this point, **DMS** should now be properly installed and configured on both the server and client devices. Once both the MotionServer and MotionClient daemons are running, **DMS** should:

 1. Watch for relevant device IDs present on the network at a regular interval
 2. Start/stop [Motion](https://motion-project.github.io/) when relevant device IDs join/leave the network
 3. Generate and send an email when an event of interest is generated by [Motion](https://motion-project.github.io/) (assuming that the MotionMail component has been installed)

#### Running a Typical Use Case
The simplest means for testing **DMS** is to remove a device from the network (*i.e.*, disable the device's networking capability), and watch (or listen, if so configured) MotionServer and MotionClient process a motion state event (in this instance, MotionServer will send an 'enable' to all clients). Recall also that individual **DMS** components can be configured to generate execution log files.

#### Unit Testing the DMS Libs Component
As an aid in troubleshooting issues (generally, they are configuration and environment-related), **DMS** is shipped with a `tests` folder as part of the Lib component. This `tests` folder contains a number of Ruby unit tests designed to verify operation of each of the library packages used in the Lib component.

To run a Lib component unit test, from the command line, change directory into the `tests` folder and run a test:

		$ ruby lib_audio_test.rb

The unit test results will be displayed as each test is completed.

To run all available Lib component unit tests, from the command line, change directory into the `tests` folder and run a test:

		$ ruby libs_test.rb
