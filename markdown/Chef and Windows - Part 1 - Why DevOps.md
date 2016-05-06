# Chef and Windows

DevOps in Windows
-----------------

Many Enterprise customers run their applications and databases in Windows owing to its ease of use, reliability, security model and updates,
software support, developer community etc. With 75% of Enterprise resources running on Windows, many IT stakeholders are in the verge of migrating their 
resources to AWS or Azure.

Once these resources are provisioned in cloud, old school techniques of managing infrastructure such as access mangement, software updates, application deployments, resource
provisioning using manual configuration or running PowerShell/VBS/BAT will become obselete and redundant especially 
if you are managing 10's to few 100's of Windows server.

What you need is a comprehensive DevOps practice and toolsets to automate end to end functionalities on multiple instances

Why Chef?
--------

Configuration management, deployment automation, continous integration etc these are some of the terminologies we hear often on DevOps world. 
In real time scenarios these functions might be overlapping. But in a nutshell Configuration management tools such as Chef, Puppet etc deals with automating server configuration and deployment of application stack on servers where as CI tools provides toolsets for source control, build, test and deploy softwares. Jenkins is one of the widely used CI tools. Meanwhile tools like Vagrant, Packer, test kitchen, cloud formation etc are used to provision servers.
Selection of the tools really boils down the complexity of infrastructure and expertise of the DevOps team. For langer enterprises with tons of customizations and automation scripts Chef or Puppet is the ideal solution. Tools like Ansible and SaltStack are good options to build fast and simple solutions while working in environments that don’t involve heavy customizations. 
Considering complexity of Windows based apps such as AD, SQL server, SharePoint, Exchange etc, I preferred CHEF over other tools for variety of reasons. Major one is AWS's own DevOps toolset "Opsworks" is built on chef and also to keep the manual configurations at minimal. 


Get started
-----------
This series is all about how to start with devops on Windows platform and how to use Chef with goal to acheive Zero Touch deployments of complex windows based applications such as SharePoint servers.
It covers end to end scenarions starting from creating a Chef workstation, to creating a simple cookbook, using a community cookbook and ends with building complex cookbooks.

---
>This blog Series

[Chef and Windows - Part 1 - Why DevOps?](markdown/Chef and Windows - Part 1 - Why DevOps.md)

[Chef and Windows - Part 2 - Configure Chef Workstation](markdown/Chef and Windows - Part 2 - Configure Chef Workstation.md)

[Chef and Windows - Part 3 - Chef basics](markdown/Chef and Windows - Part 3 - Chef basics.md)

[Chef and Windows - Part 4 - Create Win 2012 R2 instance in AWS using cloud formation](markdown/Chef and Windows - Part 4 - Create Win 2012 R2 instances in AWS using cloud formation.md)

[Chef and Windows - Part 5 - Bootstrap Win 2012 R2 instances with Chef](markdown/Chef and Windows - Part 5 - Bootstrap Win 2012 R2 instances with Chef.md)

[Chef and Windows - Part 6 - Chef install Windows Active Directory](markdown/Chef and Windows - Part 6 - Chef install Windows Active Directory.md)

[Chef and Windows - Part 7 - Chef install SQL server 2014](markdown/Chef and Windows - Part 7 - Chef install SQL server 2014.md)

[Chef and Windows - Part 8 - Chef install SharePoint 2016](markdown/Chef and Windows - Part 8 - Chef install SharePoint 2016.md)

---
>Source code

[https://github.com/spbreed/chef-and-window](https://github.com/spbreed/chef-and-windows)

---  
