
# kvm-simple-init

Simple init script to manage KVM virtual machines.

## Description

kvm-simple-init can perform the following actions on a KVM machine :

- Start

- Stop by sending a system power down event to the guest system

- Kill by stopping immediatly the QEMU emulator (automatic fallback on this
action if the VM does not respond to stop action)

- Restart

## Philosophy

kvm-simple-init focuses on simplicity, and is fully implemented in just a few
hundred lines of shell script.

It is intended for people who do not want to run libvirt just for running a few
VM, or people who prefer to manage flat configuration files using their
prefered configuration management system.

kvm-simple-init does not provide complicated configuration file format or
parameters. Only two informations are needed :

- QEMU monitor port for the machine (used to know if the VM is running, or to
send specific commands)

- Full KVM command line needed to start the machine (gives full configuration
freedom)

kvm-simple-init can be used directly as system init script for starting all KVM
machines on a host machine.  Just drop it in `/etc/init.d`, and enable it with
the tools provided by your UNIX distribution (`update-rc.d` on Debian,
`chkconfig` on Red Hat, ...).

kvm-simple-init was inspired by the init script of FreeBSD jails.

## Installation

You need to have the following tools :

- Posix shell (`/bin/sh`)
- Netcat (available via the `nc` command)
- `timeout` command (part of coreutils in Debian)
- Of course a working QEMU/KVM setup, available via the `kvm` command

Then, drop `kvm-simple-init` somewhere into your PATH (`/usr/local/sbin` could
be a good place), or into `/etc/init.d` if intended to be used as system init
script.

Currently, this tool has only been tested on Debian 6.0, Debian 7.0, Ubuntu 15.10.

## Usage

Here is the command synopsis, also found when running `kvm-simple-init` with no arguments :

~~~~~
kvm-simple-init [start|stop|restart] [VM]
~~~~~

The directory `/etc/kvm-simple-init/` contains the VMs configuration files.

The specified action (start, stop or restart) is executed :

- If VM argument is specified, using the matching file in the directory
- If not, using all files in the directory

VM configuration files should contain at least two shell variables :

- `MONITOR_PORT` :  Unique port number which need to be also specified in the
`-monitor` KVM parameter (using the `KVM_OPTS` variable below)
- `KVM_OPTS` : KVM arguments necessary to launch the VM

__Warning__ : if the virtual machine does not respond to stop action (because the operating system does not manage it, or is in a bad state), the machine will be violently interrupted.

## Example

Create `/etc/kvm-simple-init/test1` :

~~~~~
# Should be unique among all VMs
MONITOR_PORT=5805

# Not mandatory, but useful to keep it in a distinct variable
VNC_DISPLAY=5

# KVM parameters
KVM_OPTS="\
-cpu host -m 1024 -smp 1 \
-drive index=0,media=disk,file=/srv/kvm/test1.raw,if=virtio \
-vnc 127.0.0.1:$VNC_DISPLAY -monitor tcp:127.0.0.1:$MONITOR_PORT,server,nowait \
-daemonize \
"
~~~~~

Then, manage the VM with :

~~~~~
/etc/init.d/kvm-simple-init start test1
/etc/init.d/kvm-simple-init stop test1
/etc/init.d/kvm-simple-init restart test1
~~~~~

To manage all the VMs (usually when booting or stopping the system) :

~~~~~
/etc/init.d/kvm-simple-init start
/etc/init.d/kvm-simple-init stop
/etc/init.d/kvm-simple-init restart
~~~~~

## TODO

- 2013-05-30 : Package for Debian
- 2013-05-30 : Add man page
- 2013-05-30 : Add status command (also for LSB compliance)
- 2013-06-03 : Add parameter AUTOSTART to VM config

## Contributors

- Thomas Martin <thomas@oopss.org>
- MDCollins <github@m-collins.com>

## License

Copyright 2013 Thomas Martin <thomas@oopss.org>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

