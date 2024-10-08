# ArgonOne-Native-Fan-Controller
Written in Rust fan control daemon for Argon One v2 case for Raspberry Pi 4B. Fully native - unlike the official vendor controller which is just a python script. 
Easy to integrate with your operating system image building tools.

# How to use
In the [releases](https://github.com/JhnW/ArgonOne-Native-Fan-Controller/releases) tab there are already built files for Linux along with some supporting files. Download the 'package.zip' file and extract it on the Pi 4. The archive comes standard with a binary that depends on the presence of a configuration file (argon_fan_controller_cfg.yml). To build another feature variant, see the [how to build](https://github.com/kmanwar89/ArgonOne-Native-Fan-Controller/blob/main/README.md#configuration-file) section.

The repository and build artifacts contain several additional files:
- argon_fan_controller.service; file needed by systemd
- argon_fan_controller_cfg.yml; example configuration. See [Configuration file](https://github.com/kmanwar89/ArgonOne-Native-Fan-Controller/blob/main/README.md#configuration-file) for usage information
- deploy.sh; simple script to copy files to destination folders, enable i2c, and setup systemd service.

# Configuration file
The configuration file contains two directives: "interval" and "fan"

- The interval specifies the time between successive wakeup of the fan control process (in milliseconds)
    - The higher it is, the lower the CPU usage (and conversely, the lower the value, the more CPU usage is expected).
- Fan is an array of pairs, represented as temperature plus fan speed in %
    - These values must be listed in increasing (incrementing) order
- After editing the configuration file, simply issue `sudo systemctl restart argon_fan_controller.service` to apply the changes.

# Example configuration file
The following example will activate the fan control process every 500 milliseconds; the fan will run at 30% speed @ 50C, 60% speed @ 65C and 100% speed @ 70C:

```
interval: 500
fan: [50, 30, 65, 60, 70, 100]
```

# Defaults
Default values are as follows:

```
interval: 1500
fan: [55, 10, 60, 55, 65, 100]
```

The syntax for the 'fan' directive is: temp, fan speed, temp, fan speed, temp fan speed

# What's my temp?
There are several ways to retrieve the CPU temp:

1. Use a resource monitor such as [btop](https://github.com/aristocratos/btop) which displays CPU temps, usage and other useful information in a terminal-graphics format.

![image](https://github.com/user-attachments/assets/cd83add8-c923-4dd8-bcd0-936e7620de80)

2. Use the `vcgencmd` to interact with the VideoCore tool. For more information, see the [official Raspberry Pi Foundation documentation](https://www.raspberrypi.com/documentation/computers/os.html#vcgencmd) on this tool.
    - Sample syntax: `vcgencmd measure_temp`
    - Output: `temp=42.8'C`

The Pi 4 will begin throtlling at either 85C [source](https://raspberrytips.com/raspberry-pi-temperature/) or 80C according to [Tom's hardware](https://www.tomshardware.com/reviews/argon-one-m-2-case-raspberry-pi-4) so it is important to maintain temps below this value. Unless you are running heavy workloads on your Pi (transcoding, crypto mining, etc.) it's unlikely you will reach these temperatures during normal usage.

# How to build
You need install on your operating system gcc aarch64 toolchain. 
Rust need gcc linker for that architecture. Next just write for standard build:
>cargo build --target aarch64-unknown-linux-gnu --release

or for build without configuration file reading

>cargo build --target aarch64-unknown-linux-gnu --release --no-default-features

# Fork information
I am not the original author of this code and take no credit; I simply saw an opportunity to improve on the verbosity of the script output, create a removal script and update this readme for readability. All credits go to the original author.
