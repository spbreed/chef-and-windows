Chef made a great effort with their documentation. [Review this link](https://docs.chef.io/chef_overview.html) for better understanding of Chef components. On a highlevel Chef hardware components comprises Chef Server, Chef workstation, Nodes and software components include Chef client, Cookbooks, Recipes, Policies, Knife etc.
![Architecture](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image027.png)

Chef Server is a centralized repo holding all the info on Chef infrastucture such as cookbooks, policies, registered nodes, secrets etc. All the registered nodes downloads and installs the configuration information from Chef server to achieve desired state. Chef server can be installed and hosted locally or hosted chef can be used. In this series hosted chef is used. [Hosted
Chef](https://manage.chef.io/signup) lets you to register 5 nodes for free which is a great starting point for learning.

I use Windows 2012 R2 server as Chef-Workstation. I use this server to build Chef cookbooks as well as test them. Use [WinBox](https://github.com/adamedx/winbox) to configure the workstation for developers. It configures Git, ChefDK, Knife, a text editor, and other tools so you can start using it for Chef, Ruby, and other development tasks. This uses Chef Zero (Chef Solo) to configure this tools. Chef Zero is a local in-memory, fast-start Chef server intended for development purposes; it persists no data to disk, nor does it have any authentication or authorization. Chef Zero can be triggered using 
````Chef-client --local-mode````. 
Winbox kind of eats its own dog food by using a neat Chef receipe to configure workstation.

On completing the signup process for hosted chef and 2012 R2 workstation config, we are all set with Pre-req to write and test some chef cookbooks. For full blown immutable Windows infrastructure testing its recommended to use test kitchen, which provides toolings to blow up Windows servers and start from scratch. 

This workstation would be used as a sandbox environment for building and testing Chef cookbooks. It is important to to keep the WinBox configuration handy in case of tearing and rebuilding the Dev workstation which is quite possible in case of troubleshooting issues with Active Directory, SharePoint etc.

Also makesure your DEV workspace is backed up with GIT or OneDrive in a way to clone your code on any machine. I use OneDrive to sync my DEV cookbooks and use GIT to commit my production ready code.  

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
