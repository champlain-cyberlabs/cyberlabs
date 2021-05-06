# Cyberlabs Project

Welcome to Cyberlabs - a set of cybersecurity training resources focusing on host-based and network security. This repository was first created as an aid for [CyberPatriot](https://www.uscyberpatriot.org/) students to help establish a common set of training materials that can be accessible to all competitors, regardless of direct mentorship received. These lab guides are intended to cover the fundamental parts of host-based and network security that students may encounter both in a competition and in a real-world environment. Content is aimed at novice security practitioners with additional advanced concepts presented in a digestible way.

## Lab Requirements

Lab environments are distributed as Virtual Machines in `OVA` files, PowerShell scripts, and Cisco Packet Tracer files. Windows labs will require an independent Windows virtual machine for executing provided scripts to create a vulnerable environment. Linux environments can be directly downloaded and run as an appliance in Virtualization software. Cisco Packet Tracer Labs require installing [Packet Tracer](https://www.netacad.com/courses/packet-tracer) before getting started.

All lab guides are available online within this GitHub Page and are linked below. These are sourced via Markdown in the underlying repository.

# Lab Summaries

## Windows

### Windows Lab Setup

To get started on setting up a Windows lab environment, clone this repository on a machine with `git` installed:

```
git clone https://github.com/champlain-cyberlabs/cyberlabs
```

**Note that scripts included in this repository will likely be detected by Antivirus software as malicious. These scripts are only meant to be run in a virtual machine and are intended to leave an environment vulnerable for training purposes.**

Alternatively, download the latest archive of PowerShell scripts from [the releases section](https://github.com/champlain-cyberlabs/cyberlabs/releases) of this repository. All releases are protected with the password `infected` for easy download without the need to configure Antivirus exclusions. Unzip this archive in a virtual machine with Antivirus disabled to ensure that scripts run successfully.

### Available Windows Labs

**Beginner**
* [Software Auditing](windows/software-auditing/software-auditing.md)
* [System Hardening](windows/system-hardening/system-hardening.md)

**Intermediate**
* [Misconfigured Services](windows/misconfigured-services/misconfigured-services.md)
* [WebShells](windows/windows-server-webshells/windows-server-webshells.md)

**Advanced**
* [Active Directory Hardening](windows/active-directory-hardening/active-directory-hardening.md)
* [Persistence and Privilege Escalation](windows/persistence-and-privilege-escalation/persistence-and-privilege-escalation.md)
* [Process and Service Enumeration](windows/process-service-enumeration/process-service-enumeration.md)

## Linux

### Linux Lab Setup

To configure a Linux lab environment, download the associated virtual machine for the lab directly from each lab guide. Installation instructions are included before each lab.

### Available Linux Labs

**Beginner**
* [SMTP Server](linux/smtp-server/smtp-server.md)
* [Software Deep Dive & Password Hardening](linux/software-password-hardening/software-password-hardening.md)

**Intermediate**
* [Privilege Escalation](linux/privilege-escalation/privilege-escalation.md)
* [WebShells](linux/webshells/webshells.md)
* [CRON, Services, Processes and Devices](linux/cron-services-processes-devices/cron-services-processes-devices.md)


**Advanced**
* [WordPress](linux/wordpress/wordpress.md)

## Packet Tracer

### Packet Tracer Lab Setup

Ensure that Packet Tracer is installed. Labs will guide the creation of networks within blank packet tracer files.

### Available Packet Tracer labs

**Beginner**
* [Basic Network Setup](packet-tracer/basic-network-setup/basic-network-setup.md)

**Intermediate**

**Advanced**

---

### Authors

Cyberlabs began as a project created by [Ryan Mullin](https://github.com/rdmullincyber) and [Brandon Wilbur](https://github.com/brandon-wilbur/) while students at Champlain College. 
