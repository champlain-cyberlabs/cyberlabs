# Windows 10 Process and Service Enumeration Lab

**<u>Disclaimer:</u> The enclosed PowerShell script and executable file
will introduce vulnerabilities to a system upon execution for training
purposes. Do not run this outside of a virtual environment.**

<u>Requirements:</u>

-   Windows 10 virtual machine (VM) with network connectivity
-   Lab 5 PowerShell script archive

## Lab Setup:

This lab provides you with a program to run to make a virtual machine
vulnerable. **Do not run this outside of your virtual machine**. This
will make the VM susceptible to attack.

When working with the provided script, warnings can be expected from a
host machine with anti-malware programs installed. These provided
resources deal with the same remote access tools that are often
leveraged by threat actors with malicious intent.

Before powering up the VM, take a snapshot of your virtual machine if
possible. This will allow you to revert it to a clean slate after
completing the lab, allowing you to reuse the same machine after this
lab.

### Windows 10 Setup:

This lab requires a Windows 10 workstation virtual machine.

<u>PowerShell Script Steps:</u>

Extract the lab archive inside your Windows VM. This can either be done
by downloading the file inside the Virtual Machine or using VMware tools
or VirtualBox shared folders to move files between your host and virtual
machine.

Open PowerShell as an administrator. This can be done by right clicking
on the Windows icon in the bottom left corner and clicking *Windows
PowerShell (Admin)*:

<img src="media\image6.png" style="width:2.00625in;height:2.5597in" />

Disable Windows Defender and set the execution policy to allow the
script to run:

<img src="media\image28.png" style="width:5.40625in;height:0.34375in" />

Change directories to the folder containing the PowerShell script and
associated resource scripts. This will vary depending on the location of
the file and the username on the Virtual Machine. Run it with the
dot-backslash command:

<img src="media\image21.png" style="width:4.05208in;height:0.36458in" />

**Note:** This PowerShell script is not intended to be reverse
engineered to find vulnerabilities on the system, but rather emulate an
authentic vulnerable environment that was caused by other means. This
script can be removed from the virtual machine after running to
completion.

## User Accounts

For this lab, this workstation belongs to one user:

-   Toph - Local Administrator
    -   Username: `toph`
    -   Password: `E@rth!`

In this environment, Toph is a local administrator. This lab will focus
on auditing services and processes on the host and reviewing network
connections.

## Background

Programs are at the heart of operating systems and need to be organized
and managed to handle many tasks at once. In both Windows and Linux
environments, the operating system itself contains many programs for
file management, graphical user interfaces, network interactions, and
more. Almost all tasks performed by a user have an underlying process in
which the program’s code runs.

In Microsoft Windows environments, there are many expected processes
that will run on a machine even without any user interaction. Processes
have relationships to each other that are created when one process
creates another. In Windows, code that runs within these processes
usually comes from Portable Executable (PE) files stored on the file
system. These include any files that end with `.exe` (Executable) or `.dll`
(Dynamic Link Library). These files are pieces of code that are
structured specifically to run on Windows operating systems. Many PE
files are included by default on the operating system. Additionally,
third-party software installations ultimately place PE files on the file
system. The locations of these files are standard across Windows
installations and these can often be used to determine if EXEs or DLLs
are legitimate.

In Windows, processes run under the context of users. In addition to
accounts that are used for logging in by physical users, the Windows
operating system has many built-in accounts. Some of these accounts are
universal to Windows installations:

-   `Administrator`
    -   local administrator account with elevated privileges

-   `DefaultAccount`
    -   user account with normal privileges that is disabled by default

-   `Guest`
    -   user account with normal privileges that is disabled by default

-   `SYSTEM`
    -   internal Windows account that runs Windows services and processes

-   `NETWORK SERVICE`
    -   internal Windows account that handles some network authentication processes

-   `LOCAL SERVICE`
    -   internal Windows account that can be used by services

To verify the local user accounts on a system, run `Get-LocalUser` from
a PowerShell prompt.

When programs perform network connections, these are ultimately routed
through processes on a system. Auditing network connections on a system
can be done with a variety of built-in and third party applications to
harden a system’s security.

## Initial Access

Using the user account listed above, select `Toph` as the user from the
bottom left corner and login to the VM.

<img src="media\image18.png" style="width:1.59722in;height:1.77568in" />

## Process Enumeration with PowerShell

PowerShell can be used to enumerate running processes on a system
quickly without a Graphical User Interface (GUI). From an administrative
PowerShell system, use the `Get-Process` commandlet:

<img src="media\image4.png" style="width:4.52083in;height:1.19792in" />

By default, this will list out some basic information about processes
running on the system. To get more precise information and options
available, use the `Get-Help` PowerShell commandlet. Before using this
command, run `Update-Help` to download the latest help information. You
can expect a few failures after running this:

<img src="media\image20.png" style="width:2.64583in;height:0.51042in" />

After this command, run the `Get-Help` command on `Get-Process`:

<img src="media\image12.png" style="width:3.33333in;height:0.47917in" />

This will now list out various parameters that can be added to the
`Get-Process` command to produce more information. For example, the
`-IncludeUserName` flag can be used to specify which user is
running each process:

<img src="media\image2.png" style="width:5.17708in;height:1.26042in" />

## Task Manager

One built-in method for auditing processes can be done with Task Manager
on Windows. This can be used to view basic information and resource
usage on a system from each process. While useful, Task Manager is
relatively limited in showing process relationships and more advanced
information.

<img src="media\image15.png" style="width:4.15248in;height:2.80903in" />

## Process Explorer

Windows Sysinternals is a very popular suite of tools that includes
applications that can help discover what processes are running on a
system. On this VM, Process Explorer has been installed and a shortcut
is on the Desktop.

In order to see activity happening from all processes on the machine,
make sure to right-click on the Desktop shortcut and run it as an
administrator:

<img src="media\image10.png" style="width:3.02509in;height:1.53472in" />

Within Process Explorer, process relationships are shown. When one
process creates another, a parent-child relationship is formed. Many of
these relationships can be used to determine if a process is legitimate
or trying to hide as a fake Windows process. In Process Explorer, a
process entry will be nested underneath parent processes to quickly
identify these relationships.

<img src="media\image3.png" style="width:6.14583in;height:3.94792in" />

One of the best ways to learn more about Windows processes is by
searching the web for process names shown in Process Explorer. If it is
a legitimate Windows process, there is likely Microsoft documentation
providing details.

When mousing over a process entry in Process Explorer, command line
arguments and paths are shown. Process Identifiers (PIDs) are shown
under the PID column that also provides a way to identify processes.
While processes can share the same name and even be started from the
same location and share the same path to an EXE or DLL, no two processes
can share the same PID. For this reason, PIDs are commonly used to
distinguish between processes on a system. Note that nearly all process
IDs are randomly generated by Windows and are unlikely to be the same
even if a process is killed and restarted from an EXE or DLL.

The two exceptions to this rule are the `System` and `System Idle Process` processes. `System` is the main process Windows uses to handle
memory and will always have a PID of `4`. The System Idle Process will
always have a PID of `0` and occupies free processor space that isn’t
being used on the machine. If a machine has 90% of its processor being
used, the System Idle Process can be expected to hover at 10%. Likewise,
if only 10% of the processor is being used, the System Idle Process will
be around 90%.

## CurrPorts

Nirsoft CurrPorts is one piece of freeware that is intended to discover
network connections on a system. This can be useful in identifying
backdoors on a system that may be communicating with attackers or to
ensure that unnecessary ports are not running on a system.

A shortcut to Nirsoft CurrPorts has been placed on the Desktop of the
VM. Right click on the icon and select Run as administrator to ensure
that all connections can be viewed in the software:

<img src="media\image26.png" style="width:3.13194in;height:1.45377in" />

After launching the program, network connections are shown per process
with many details.

<img src="media\image1.png" style="width:6.5in;height:3.13889in" />

In networking, port numbers are used to identify services. Well-known
ports and services use the System Port range, defined by the Internet
Assigned Numbers Authority (IANA)
[<u>here</u>](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml).
Outside of this range, IANA suggests using ports `49152` to `65535` for
private services. While this is a recommendation, users aren’t limited
to just using ports from this range. A variety of legitimate services on
Windows and other third-party programs use ports all across usable
ranges.

When connections are made to a remote server, there is a destination
port and a source port that help identify what the connection is going
to be related to. For example, web servers use port `80` for HTTP and port
`443` for HTTPS. It’s likely that even without user interaction, HTTP and
HTTPS connections are being made on your VM as part of Windows and third
party services. For interacting with a server, port numbers can be used
to identify what service is being accessed. For example, connections
with a local port of `80` or `443` could mean that HTTP or HTTPS connections
are coming into your local workstation. On the other side, outbound
connections with a remote port of `80` or `443` are normal for interacting
with a remote server over HTTP or HTTPS. On the side initiating the
request, a random ephemeral port can be expected. This is a port that is
randomly selected for a network connection on the client and is often a
high port number.

When looking for backdoors, there are two popular kinds of network
connections when remote shell (command line) access is desired. One of
the most popular backdoors, a reverse shell, communicates by initiating
a connection to a remote server. This often circumvents firewall
defenses, as it forces an infected machine to start a connection to an
attacker’s computer. Another type of backdoor is a regular shell, where
a port is opened on a victim machine and waits for an attacker’s
incoming connection. In either scenario, local and remote ports will be
of interest and the process performing the connection will be important
for analysis.

## Windows Remote Management

One Windows service that is often present on systems is Windows Remote
Management (WinRM). WinRM is a Windows service often used in a similar
way to SSH. The standard port used for this service is `5985`. Locate this
connection and associated process in CurrPorts.

WinRM is a feature of Windows, so this will be running under PID `4` as
the System process. Toph doesn’t need this service on her computer, so
it can be disabled. While this process cannot be terminated, the service
can be disabled manually to prevent future network connections over this
port. From an administrative PowerShell prompt, run the following
command:

<img src="media\image23.png" style="width:4.20833in;height:0.97917in" />

After this command, the VM will need to be rebooted before this port is
no longer being used in network connections on the system and previous
instances of WinRM are terminated.

**Svchost Network Connections**

After browsing connections in CurrPorts, a few entries should be visible
that are highlighted in red. These connections are identified by
CurrPorts as unusual connections that are not normally seen in Windows.
Look at the different versions of `svchost.exe`. Can you spot a difference
between the one in red and the others in the list?

`svchost.exe` is a legitimate process that is intended to host Windows
Services. Legitimate versions of this program are launched by the parent
process `services.exe`. In Process Explorer, mouse over all the various
instances of `svchost.exe` and observe the command line arguments.
Legitimate versions of `svchost.exe` will have some command line
arguments that describe what service is going to be running inside the
process, and the executable file will be located within
`C:\Windows\System32`.

<img src="media\image8.png" style="width:4.71875in;height:1.10417in" />

Using this information, we know that any version of `svchost.exe`
outside of this location and without standard arguments should be
suspicious. In CurrPorts, find `svchost.exe` that is listening on port
`28354` and find the location of this file. This is in a non-standard
location and doesn’t have a parent process of `services.exe`.

Right click on this process in Process Explorer and examine the
properties of the process. The parent process will be designated as
non-existent, and command line arguments will have parameters that
aren’t consistent with a legitimate `svchost.exe` process. A
non-existent process means that the parent process of the currently
running one has stopped. Additionally, note the *Started* field. This
will designate when the process was started on the system. Is this close
to the time that the virtual machine was started?

<img src="media\image9.png" style="width:6.5in;height:4.08333in" />

Repeat this process and identify any other suspicious programs that may
be in non-standard locations using CurrPorts and Process Explorer. Take
note of the file locations, command line arguments, and process IDs.

## Autoruns

Autoruns is another Microsoft Sysinternals tool that is used to see what
is set to automatically run on a system. Due to the processes starting
close to the time of the VM startup, we can assume that these may be
automatically configured in Windows to start. Launch Autoruns with
administrator privileges from the Desktop shortcut.

<img src="media\image7.png" style="width:4.35687in;height:3.01389in" />

Under the Everything tab, all various ways that programs can be
automatically run is displayed. As with CurrPorts, items in color are
potential items of interest. Audit this list and find any more
references that may be of interest.

<img src="media\image16.png" style="width:6.5in;height:1.19444in" />

Under the Task Scheduler category in Autoruns, a reference to the file
`C:\windows\temp\cloud-security.ps1` is present. Go to this file and
view it. What kind of file is this, and what does it contain? Locate the
file within File Explorer, right click, and select *Edit* to open this
PowerShell script in the PowerShell ISE.

<img src="media\image14.png" style="width:6.35417in;height:1.66667in" />

This is a PowerShell script containing an encoded command. Attackers
often use encoded commands to obfuscate their activities and evade
detection. In this case, the PowerShell `-EncodedCommand` parameter
looks for Base64-encoded data to decode and execute. Base64 data can be
decoded and encoded in a variety of ways. One of the easiest ways to
decode and work with unknown data, including Base64, is CyberChef.
CyberChef is an open source tool that is publicly available
[<u>here</u>](https://gchq.github.io/CyberChef/). To decode the data,
drag the *From Base64* and *Remove Null Bytes* recipes from the left
column and paste the data between the double quotes in the PowerShell
script:

<img src="media\image19.png" style="width:6.5in;height:3.56944in" />

After decoding, we can see that this script is used to run
`windows.exe`. At this point, we know that `windows.exe` in this
location is not legitimate.

## VirusTotal

Another great way to verify any suspicious EXE or DLL files on the
system is using VirusTotal, a service that uses many different antivirus
programs to analyze a file. Files can either be uploaded directly to the
service through a webpage, or searched for by file hash. While files can
be uploaded directly and analyzed, files uploaded to the service can be
downloaded from VirusTotal by those with premium licenses. For this
reason, it is a best practice to search for file hashes before uploading
files, and especially refrain from uploading files that are
confidential.

Additionally, uploading a file that has previously been unseen on
VirusTotal can alert an attacker that they have been discovered

After reviewing all the entries in Autoruns, an entry should be present
referencing a file named `onedrive.exe`:

<img src="media\image13.png" style="width:6.5in;height:1.01389in" />

We can first check VirusTotal for this file's hash to see if it has been
uploaded before. This can be done using an administrative PowerShell
prompt:

<img src="media\image24.png" style="width:6.5in;height:1.61111in" />

Copy this value by highlighting the hash and pressing *Enter*. Go to
[<u>VirusTotal</u>](https://www.virustotal.com/gui/home/search) and
paste the hash into the search bar:

<img src="media\image27.png" style="width:6.5in;height:3.375in" />

According to VirusTotal results, this file has been previously submitted
and 49 antivirus engines detected this file. Using this context, it is
near certain that this file is malicious. Likewise, this same searching
procedure can be used for other files on the operating system that may
look suspicious.

## Remediation

Sysinternals tools and CurrPorts can be used to help speed up the
remediation process and aid in removing identified malware from the
system. In Autoruns, right click on any malicious entries and click
delete. This will delete the persistence mechanism that enables this
malware to run automatically.

<img src="media\image11.png" style="width:6.5in;height:1.5in" />

In CurrPorts, processes that have been deemed malicious can be killed
through the right click menu:

<img src="media\image25.png" style="width:6.36458in;height:4.47917in" />

Additionally, Process Explorer can be used to kill any bad processes and
also locate the EXE or DLL files that are running inside a process:

<img src="media\image5.png" style="width:3.94792in;height:3.40625in" />

After terminating the malicious processes, make sure to remove all
instances of the malicious files and scripts from the file system. This
can be done in a command line utility like PowerShell or the Windows
Command Line, or File Explorer. To ensure that the system has been
remediated, restart the VM and run the previously mentioned tools again.
If successful, the processes and their associated network connections
should no longer be running.

## Firewall Remediation

Another way that network connections can be limited on a system is
through host-based firewalls. On Windows, the Windows Defender Firewall
is used to allow and deny programs access to network connections. Open
this program by searching in the Windows Search Bar:

<img src="media\image29.png" style="width:3.00609in;height:5in" />

In the Windows Defender Firewall, there are two main profiles, private
and public. On public networks, restrictions are generally more strict
than private networks. This is based on the assumption that a private
network is shared with trusted devices, and a public network is not. For
each of these profiles, rules exist to allow or deny network connections
based on certain criteria. Click on *Advanced Settings* on the left
sidebar to browse the firewall rules that Toph has set:

<img src="media\image17.png" style="width:3.39583in;height:1.92708in" />

Inbound Rules are most important in ensuring that attackers cannot make
incoming connections to Toph’s computer. Expand the *Program* column to
look for any rules that allow specific executables to communicate. Right
click on these rules and delete them to harden the system:

<img src="media\image22.png" style="width:6.5in;height:1.81944in" />

By default, many services are enabled by default in Windows. To better
harden a system, default rules can often be disabled that allow certain
programs or services to communicate to better suit the needs of a user
and reduce a system’s attack surface.
