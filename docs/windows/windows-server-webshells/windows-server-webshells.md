# Windows Server WebShell Lab

**Disclaimer: The enclosed PowerShell script and executable file
will introduce vulnerabilities to a system upon execution for training
purposes. Do not run this outside of a virtual environment.**

<u>Requirements:</u>

-   Windows Server 2019 virtual machine (VM) with network connectivity in NAT mode
-   Webshell PowerShell scripts archive

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

Ensure that this Virtual Machine is connected in NAT mode. This will
allow connectivity to the web server from both the host machine and
other virtual machines on the same host machine.

### PowerShell Script Steps:

Extract the lab archive inside your Windows VM. This can either be done
by downloading the file inside the Virtual Machine or using VMware tools
or VirtualBox shared folders to move files between your host and virtual
machine.

Open PowerShell as an administrator. This can be done by right clicking
on the Windows icon in the bottom left corner and clicking *Windows
PowerShell (Admin)*:

<img src="media\image14.png" style="width:2.00625in;height:2.5597in" />

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

For this lab, we will be using one user:

-   John - Administrator
    -   Username: `john`
    -   Password: `Passw0rd!`

## Background

This is a Windows Server environment intended to emulate a web server
that might exist on a public network that is accessible to the world.
While the presence of Linux on the Internet is very strong, Microsoft
also maintains a sizable portion of web server usage with [<u>Internet
Information Services (Microsoft IIS)</u>](https://www.iis.net/overview).

Web servers are what power websites to deliver content to users. By
default, content will usually be accessed over Hypertext Transfer
Protocol (HTTP) over port 80 on a web server. Though this can change
when encryption is used (HTTPS), the underlying HTTP protocol is most
often used to retrieve data from a web server.

Many different types of content are served up from web servers, with two
main categories:

<u>Static Content</u>

Static websites are pages that don’t have any processing that goes on in
the background that needs to happen to render a web page. Standard
[<u>Hypertext Markup Language
(HTML)</u>](https://en.wikipedia.org/wiki/HTML) is used on static web
pages to deliver content to users that is unchanging. This means that
once an HTML or other file is written to a server, the page will be
delivered to the user as it was written.

<u>Dynamic Content</u>

Dynamic websites are increasingly common and allow much more flexibility
on the web. Social media sites, blog sites, and any sites with
non-repeatable content are considered dynamic sites. This allows a web
server to offer users the ability to upload files, stream videos, and
interact with a site through various inputs. This is what powers social
media sites, browser-based email, and video streaming services. This
often can have a negative impact on security for numerous reasons.

In this scenario, the virtual machine that you are accessing is a small
web server with some static and dynamic content hosting some security
training resources.

## Initial Access

Login to the VM as John. The content on this server can be examined by
directly searching through the file system and accessing the web server
with a browser. Inside the virtual machine, click on the Windows search
bar, type *cmd*, and click on the Command Prompt:

<img src="media\image18.png" style="width:2.51042in;height:4.125in" />

Inside the command prompt, run the `ipconfig` command to obtain the
virtual machine’s IP address:

<img src="media\image9.png" style="width:5.57292in;height:3.14583in" />

Take note of the value marked `IPv4 Address`. This will be the address
that can be used to access the server. If the virtual machine is
configured in NAT mode, this IP address should be accessible from a web
browser on the host machine:

<img src="media\image19.png" style="width:6.13542in;height:2.42708in" />

If another machine is not available, the `localhost` address or IP
address of the machine can be used on a web browser on the server
itself. If Internet Explorer is used, ensure that Internet Explorer
Enhanced Security Configuration is disabled in the *Local Server*
section of the Server Manager:

<img src="media\image2.png" style="width:2.30208in;height:1.67708in" /><img src="media\image11.png" style="width:4.64583in;height:2.38542in" />

<img src="media\image1.png" style="width:4.89583in;height:1.79167in" />

For exploring the server’s files directly, you will need to explore the
contents of the web server’s root directory. This is the overarching
folder that contains the content accessed over the web. The folder
structure in a web server’s root directory matters for serving up
content.

Sending a request for the website’s root page is synonymous with typing
in the IP address with a single slash or no slash in a web browser. By
default, `index.html` is the file that is served up when requesting the
website’s root page.

Navigate to `C:\inetpub\wwwroot` on the server. This is the default
folder, or root directory, that Microsoft IIS will use to serve up
pages. Examining the contents of the website’s root directory shows that
the file `index.html` is the default page served up at the website’s
root:

<img src="media\image25.png" style="width:4.30713in;height:2.53958in" />

Enable file name extensions in Windows Explorer to examine the types of
files on the server:

<img src="media\image7.png" style="width:6.5in;height:1.45833in" />

Right-click on index.html and click *Open with* and then *Choose another
app*:

<img src="media\image16.png" style="width:5.42708in;height:2.5625in" />

Select *More apps* and then *Notepad* to examine the contents of the
file:

<img src="media\image10.png" style="width:3.83333in;height:5.125in" />

The raw HTML is visible in this file. HTML is composed of various tags
encapsulated in `<>` symbols and is relatively easy to start
learning. Search for different tags
[<u>here</u>](https://www.w3schools.com/tags/) or with a search engine
to understand what each tag does on a page.

<img src="media\image15.png" style="width:5.21875in;height:2.42708in" />

## Exploring Web Directories

As we saw previously, the location of `index.html` automatically served
up the page when the root web page of the server was requested. From the
web browser, click on *Training Resources* and take note of the URI bar.
The actual file structure of the web server mimics the slashes in the
URI that denote folders. Inside the `training` directory on the file
system, the page’s raw HTML can be opened in Notepad using the same
method as before.

Explore the pages on the server in a web browser. Do you notice any
other file types than HTML?

The file located at `/uploads/uploader.aspx` is one example of dynamic
content on a site. This gives the ability for users to upload files to
the web server. Try uploading an image through this page to the server.
Can you locate where the uploaded file went on the server?

## IIS Dynamic Content Overview

Using the same method as before, open `uploader.aspx` in Notepad. This
bears some noticeable similarities and differences to HTML files. ASPX
stands for Active Server Page Extended and is part of the Microsoft
solution for dynamic web content. ASP.NET is the overarching solution
that encompasses web developer programs used on Windows Servers to
provide dynamic content on web sites.

A page’s language can be discovered in the first line of the page, as
multiple languages are supported in ASPX sites. In `uploader.aspx`, note
the `UploadButton_Click` function:

<img src="media\image12.png" style="width:5.20833in;height:0.86458in" />

Note that `saveDir` is referencing a folder called `uploads`. Using this
information, locate the file that you previously uploaded.

## Security Implications

Take note of the location of your file on the web server’s file system,
and try to navigate in a web browser to the image that you previously
uploaded. This should be a path of `/uploads/` followed by your file
name. If the file name was `drupal.png`, the path to access that image
through the web server might look like this:

<img src="media\image24.png" style="width:5.14792in;height:3.24001in" />

With images in this case, there is little security concern about
malicious usage on a web server. When further dynamic content is
introduced, however, this can become a problem.

Note the file `index.asp` inside the uploads directory. Open up this
file in Notepad. Can you figure out what it’s doing?

Request this file through the web server by typing in the server’s IP
followed by `/uploads/index.asp`.

<img src="media\image5.png" style="width:6.5in;height:4.625in" />

Go to the input bar and type `ping google.com`. The output of this
command should be displayed on the page after it runs.

This is an example of an Active Server Page (ASP) webshell. ASP precedes
ASPX in age but maintains similar features. Placing a command in the
input box and clicking *Run* will execute this command on the server.
Inspecting the file itself shows that this web shell is placing the
command on the request line as part of the HTTP GET request.

<img src="media\image26.png" style="width:5.70833in;height:0.55208in" />

The above line shows that the command itself is present in the request
URI.

<img src="media\image6.png" style="width:5.67708in;height:0.84375in" />

Due to the file uploader page present on this site, this file could have
been placed here from an intentional malicious upload. When files are
uploaded into web-servable directories that serve up dynamic content,
the risk of web shells allowing remote access to the server is high.

Inspect other files in this directory. Another file, `myfile.aspx` is
present inside of the uploads directory. Inspect its contents and take
note of what you see. Now, try to access this file with a web browser.
Can you find the password inside the file contents?

<img src="media\image8.png" style="width:6.45833in;height:0.8125in" />

The default password `admin` is located in cleartext in `myfile.aspx`
here. Enter it into the page and explore this site. Through this web
shell, an attacker can execute commands, browse the file system on the
server, and more. Through uploading this file, an attacker can now
maintain access to the server by using this page.

## Mitigation

Web server misconfiguration and lack of input sanitization are some of
the most popular reasons why web shells are introduced on web servers.
Though the uploads site tells the user to upload an image, the server
does not check that these files are truly images. Further, putting these
files in a location that they can be served up as pages puts the server
at risk.

One fix to this problem would be to put files in a place where they
can’t be served up by the web server software - outside the root web
directory. Create a new folder called `Uploads` under the `C` drive. Edit
its permissions:

<img src="media\image21.png" style="width:4.51042in;height:2.46875in" />

Add the web server’s user group, `IIS_IUSRS`:

<img src="media\image3.png" style="width:4.11458in;height:3.01042in" />

Now, make sure that this group has full control over the folder:

<img src="media\image27.png" style="width:2.72917in;height:3.16667in" />

Now, to edit where `uploader.aspx` is placing its files, right click
Notepad in the start menu to open it as an administrator:

<img src="media\image17.png" style="width:3.65625in;height:1.23958in" />

In Notepad, open up the `uploader.aspx` file through the *File -&gt;
Open* menu. Change the file to look like the following:

<img src="media\image13.png" style="width:5.52083in;height:4.05208in" />

This will comment out the `appPath` variable and change the `saveDir`
variable so the application uploads files to the new directory that
isn’t directly served up by the server. Save this file and test
uploading an image again. If this is successful, the uploaded file
should be created in the directory `C:\Uploads`.

**Detections**

For webshells such as `index.asp` that we found passing commands in GET
requests, logging URIs accessed on the server can be extremely helpful
in detecting webshell activity. To enable logging for this site, open
PowerShell as an administrator and type the following command:

<img src="media\image4.png" style="width:6.5in;height:1.29167in" />

To demonstrate this logging, access `index.asp` through the web browser
and type in the command `whoami`. This is a command used by
attackers to check what user they are running commands as.

Now, to check this file, open explorer and navigate to the directory
`C:\inetpub\logs\LogFiles\W3SVC1`. Open the file ending in `.log`.
The command that was executed through this webshell can be seen as part
of the request URI:

<img src="media\image22.png" style="width:5.76042in;height:0.9375in" />

While this method can be used to detect webshells using GET requests,
POST requests will not be fully logged. This is due to POST requests not
passing along details in the URI. This can be noted by visiting
`myfile.aspx` in a web browser and viewing the URI bar in the browser.

While network detection mechanisms in this case will involve more
complex traffic monitoring, checking file hashes is also a great way to
detect common webshells. In an administrative PowerShell prompt, the MD5
file hash of `myfile.aspx` can be found using the following command:

<img src="media\image20.png" style="width:5.41667in;height:1.59375in" />

Copy this file hash and visit
[<u>https://www.virustotal.com/gui/home/search</u>](https://www.virustotal.com/gui/home/search).
Paste in this hash and press enter. VirusTotal is a service that will
compare hash detections among many providers to try to determine if a
file is malicious. For providers that marked the file as detected (in
red), do you notice any common signature names?

This file is an ASPXSpy webshell that is commonly used by attackers all
over the world, and is [<u>noted by
MITRE</u>](https://attack.mitre.org/software/S0073/) as a common piece
of malware used for attacks. Automatically scanning for hashes on web
server directories, especially user upload directories, is a good
detection mechanism for webshells that are commonly used.

## Remediations

Once a web shell has been identified, the best way to remediate the
threat is to remove it from the web directory. If files are wanted for
further analysis, they can be moved to a different location on the
machine where they can’t be served up by the web server software. Test
this with the web shells that were identified by deleting them or moving
them to a folder outside of `C:\inetpub\wwwroot`. Try to request these
files in a web browser. If these requests fail, the remediation was
successful.
