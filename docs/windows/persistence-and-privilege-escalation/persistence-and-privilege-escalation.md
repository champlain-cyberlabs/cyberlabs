# Windows 10 Persistence and Privilege Escalation Lab

**Disclaimer: The enclosed PowerShell script and executable file
will introduce vulnerabilities to a system upon execution for training
purposes. Do not run this outside of a virtual environment.**

<u>Requirements:</u>

-   Windows 10 virtual machine (VM) with network connectivity
-   Persistence and Privilege Escalation PowerShell script
-   (Optional) Kali Linux Virtual Machine or other machine with Ncat installed

## Lab Setup:

This lab provides you with a program to run to make a virtual machine
vulnerable. **Do not run this outside of your virtual machine**. This
will make the VM susceptible to attack.

When working with the provided script and executable, warnings can be
expected from a host machine with anti-malware programs installed. These
provided resources deal with the same remote access tools that are often
leveraged by threat actors with malicious intent.

Before powering up the VM, take a snapshot of your virtual machine if
possible. This will allow you to revert it to a clean slate after
completing the lab, allowing you to reuse the same machine after this
lab.

### PowerShell Script Steps:

Move this file to your Windows VM. This can either be done by
downloading the script file inside the Virtual Machine or using VMware
tools or VirtualBox shared folders to share files between your host and
virtual machine.

Open PowerShell as an administrator. This can be done by right clicking
on the Windows icon in the bottom left corner and clicking *Windows
PowerShell (Admin)*:

<img src="media\image18.png" style="width:2.00625in;height:2.5597in" />

Change directories to the folder containing the PowerShell script. This
will vary depending on the location of the file and the username on the
Virtual Machine. Set the execution policy to allow the script to run,
and then run it with the dot-backslash command:

<img src="media\image23.png" style="width:4.77083in;height:1.60417in" />

**Note:** This PowerShell script is not intended to be reverse
engineered to find vulnerabilities on the system, but rather emulate an
authentic vulnerable environment that was caused by other means. This
script can be removed from the virtual machine after running to
completion.

## User Accounts

For this lab, we will be using three users:

-   Ariel - Administrator
    -   Username: `ariel`
    -   Password: `password`

-   Alex - Standard User
    -   Username: `alex`
    -   Password: `password`

-   Bob - Standard User
    -   Username: `bob`
    -   Password: `password`

## Initial Login

To investigate vulnerabilities on the machine, login to the VM as Ariel.
When prompted to choose privacy settings, keep the default values and
continue.

Watch the screen after logging in. Do you notice anything unusual about
the interface?

Note the Windows taskbar:

<img src="media\image5.png" style="width:6.5in;height:0.86111in" />

Click on the highlighted command prompt icon. What’s visible in the
window?

<img src="media\image3.png" style="width:6.5in;height:1.02778in" />

Take note of the prompt and commands shown. What could we use here to
investigate further?

Using the file path that you identified, open Windows Explorer and try
to navigate to the folder mentioned above. Can you get to this location?

Though the folder isn’t visible by default, it still exists on the
filesystem as a hidden item. Click the following box under the View menu
in Explorer to view Hidden items:

<img src="media\image4.png" style="width:6.5in;height:2.76389in" />

Now you should be able to view the contents of this folder. What files
do you see here?

Alternatively, items that are hidden in this way can be viewed with the
Windows Command prompt. The `cd` command will change directories, and
`dir` will list items in the current directory:

<img src="media\image2.png" style="width:4.54167in;height:3.20833in" />

Right-click the Windows Batch File titled `startup` and click edit to
view the contents of the file. What do you notice?

<img src="media\image22.png" style="width:5.60417in;height:0.75in" />

This is a Windows Batch File that calls another program. In this case,
it is running the command `start` and calling `n.exe` located in
`C:\Program Files\Windows` with multiple arguments.

Microsoft often publishes documentation on built-in commands and
programs that can help you understand what is happening. [<u>This
link</u>](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/start)
has more information about the start command and what each argument can
do.

The directory, `C:\Program Files\Windows`, doesn’t exist on a
standard Windows 10 system. This was created as a look-alike to make it
more difficult for the victim to find. Attackers often name files and
folders to mimic built-in features to make defenders pass over malicious
files.

### Remediation Steps

Once we’ve identified that this executable and batch file are unwanted,
they can be removed by deleting them in Windows Explorer as if they were
any other files on the operating system. As the batch file calls `n.exe`
from this specific directory, the two files could also be moved via
*Cut* in the right-click menu and pasted elsewhere to stop `startup.bat`
from successfully running. Note that Administrator privileges will be
required to modify items within the `C:\Program Files\Windows` directory.

<img src="media\image6.png" style="width:2.03566in;height:2.23542in" />

## Windows Startup Folder

One common way that attackers establish persistence is by adding entries
to startup folders. Multiple startup folders are used by Windows to
automatically run programs when a computer starts or when a user logs
in. Access to the system-wide startup folder should only be given to
Administrators or else any user could cause a program to run when the
computer starts.

<u>System-Wide Startup Folder Location:</u>

`C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp`

<u>User Startup Folder Location:</u>

`C:\Users\<username-here>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

Check the contents of these folders. If you have trouble finding them,
make sure Windows Explorer is configured to view hidden items. For
Ariel’s startup folder, make sure you substitute `<username-here>`
for `ariel`. Do you notice anything unusual in either of these folders?

Right-click on the shortcut titled `startup` in the system startup
folder and open *Properties*. Does the value in the *Target* section look familiar?

This is an `.lnk` file, or Windows shortcut file, to the script that was
previously seen. On startup, this will run the previous script as the
current user. If unsecured, other standard users on the system could
place files in this folder to get them running when an administrator
logs in.

Go back one directory and right-click on the Startup folder and select
*Properties*. Click on the *Security* tab. Keeping the previous information
in mind, what doesn’t look right here?

<img src="media\image20.png" style="width:3.78125in;height:5.13542in" />

All users on the computer are part of the *Users* group. This means that
Bob and Alex could put files or scripts into this startup folder so that
they can run programs under the privileges of Ariel when she logs in.

## Windows Registry

The Windows Registry is a database of values that control key features
of the Windows operating system. This is also something that is often
abused by attackers to manipulate the normal functioning of a system.
This database is similar to a folder-file structure, except each
high-level folder is called a registry hive.

Type *registry* into the Windows search bar and right-click *Registry
Editor* to open it as an administrator. This is one way to explore the
Windows Registry.

<img src="media\image17.png" style="width:2.78125in;height:4.33165in" />

The Windows Registry can be complex. Here’s the high-level structure of
the registry unexpanded:

<img src="media\image16.png" style="width:2.17708in;height:1.97917in" />

For privilege escalation, two notable hives are `HKEY_CURRENT_USER`
and `HKEY_LOCAL_MACHINE`. The current user hive will hold values for
the current user, whereas the local machine hive will hold system-wide
values. Within each of these hives are the following keys that deal with
startup activity:

```
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run

HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run

HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce

HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce
```

As their names suggest, each one of these registry keys will run
programs on startup. Whereas *RunOnce* keys will run a single time and
then reset themselves, *Run* keys will run programs at every system
startup. These registry keys are called *Registry Run Keys*.

In terms of privilege escalation, the Run keys under the
`HKEY_LOCAL_MACHINE` hive are very important to note, as they will run
regardless of who logs in.

Look at the values of each one of these above keys by typing into the
navigation bar or by navigating through clicking the arrows to the left
of each folder in the registry editor. What did you find?

Examine the `(Default)` value in
`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`.
At startup, this will use PowerShell’s `Start-Process` command to run
the same program, `n.exe`, that we previously observed. Take note of the
arguments within this registry value. Do they differ from the previous
instance?

### Remediation Steps

Multiple values in registry run keys are common. Removing a malicious
run key can be done by changing the value or by deleting it entirely.

<img src="media\image7.png" style="width:2.92708in;height:1.57292in" />

## Scheduled Tasks

Scheduled tasks is another feature in Windows that can be abused for
privilege escalation. Click on the Windows search bar, type *task
scheduler*, and open the program.

<img src="media\image10.png" style="width:2.37292in;height:4.06902in" />

Click on *Task Scheduler Library* and look at the various tasks on the
system. Most legitimate Microsoft tasks are created with descriptions
and have specific schedules. Do any tasks look suspicious?

<img src="media\image15.png" style="width:6.5in;height:1.75in" />

Right-click the task titled *STARTUP* and click on *Properties*. Note that
the task will run as `SYSTEM`:

<img src="media\image11.png" style="width:4.47917in;height:3.09375in" />

Under the *Triggers* tab, you can see that this runs at system startup:

<img src="media\image13.png" style="width:3.52083in;height:1.71875in" />

And under *Actions*, you can see that this task will run the following
program:

<img src="media\image12.png" style="width:3.91667in;height:1.72917in" />

This scheduled task will run the previously identified script, but under
the permissions of `SYSTEM`. This account is the highest-privileged
account on any Windows machine. Through creating a scheduled task, one
user may be able to escalate their privileges to run a program under
`SYSTEM`-level privileges.

### Remediation Steps

In the Windows Task Scheduler, tasks can be deleted or disabled by
right-clicking on the highlighted task:

<img src="media\image9.png" style="width:4.375in;height:2.69792in" />

## Looking at Network Activity

The Windows Command Line can be used to find out information about what
network connections are currently in use on the system. One common
program is `netstat`. To run `netstat`, Administrator privileges need to be
used. Type *cmd* in the windows search bar, right-click command prompt
and run command prompt as an administrator:

<img src="media\image19.png" style="width:2.63125in;height:4.2387in" />

In the command prompt, type `netstat -nab`. This will run `netstat` with
options to show details numerically, show associated processes, and
display all connections.

Scroll through the list of connections. Do you see any references to the
previous information that you uncovered?

<img src="media\image1.png" style="width:5.5625in;height:4.01042in" />

Multiple entries for `n.exe` that were previously seen in a folder can
be seen making network connections. Port numbers such as `46255` that were
seen in previous commands can be seen in use here. This is an excellent
way to monitor suspicious processes that are making network connections
on a system.

## Attacker Perspective

Now that we’ve identified vulnerabilities present on the system, we can
see what they look like from an attacker’s point of view. Recall
previous notes about `n.exe` and the network connections that it was
creating.

`n.exe` is an example of [<u>`Ncat`</u>](https://nmap.org/ncat/) (formerly
called Netcat) being used as a backdoor. `Ncat` is a multipurpose
command-line tool that can be used for network operations. It is also
commonly used by attackers to steal data and establish easy-to-use
backdoors. As seen in multiple places in the operating system, arguments
were constructed like the following:

```
n.exe -l -p <PORT-NUMBER>; -e cmd
```

This tells `Ncat` to act as a listener on a specified port, and to allow
connections to run a command prompt remotely. The full list of Ncat’s
options [<u>can be found
here.</u>](https://nmap.org/book/ncat-man-options-summary.html)

The &lt;PORT-NUMBER&gt; placeholder was changed multiple times. Go back
to the netstat command and previous notes and observe the various port
numbers used by `Ncat`. These will be used by the attacker to connect to
the vulnerable Windows system.

To simulate the attacker, we need to get the workstation’s IP address.
Open a command prompt and type `ipconfig` and take note of the value
under `IPv4 Address`. The specific address on your system is likely to
be different from the example shown below.

<img src="media\image8.png" style="width:5.67708in;height:2.11458in" />

From the attacker machine with `Ncat` installed, type `nc
<IP-ADDRESS> <PORT>` and substitute your IP address in and
type one of the port numbers previously identified. If successful, a
Windows command prompt should display on the attacker’s terminal. Type
`whoami` after successfully connecting to view what user you are
impersonating. This will dictate the privileges that the attacker
possesses on the machine.

Port `46260`:

<img src="media\image14.png" style="width:4.47917in;height:1.73958in" />

Port `46255`:

<img src="media\image21.png" style="width:4.44792in;height:1.64583in" />

As demonstrated by these connections, the scheduled task running the
batch script successfully ran Ncat as the `SYSTEM` account over port
`46260`. The registry run key also ran Ncat over `46255` under the
privileges of Ariel’s account.
