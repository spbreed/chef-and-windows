Though you can find most common Chef recipies online, still its crucial to learn how to build custom chef recipies. At the time of inception hardcore Ruby is used to define any resource or recipe with in Chef. But eventually Opscode build these wrapper functions called Low Weight Resource Providers (LWRP) to call Chef functions. These LWRP wrappers follow a syntax which is felxible and easier to understand. In cases of writing complex functions using classes, objects etc HWRP's are used, those are pure ruby. It's also possible to embed other languages such as PowerShell, Shell scripts, BAT scripts etc with in the Chef cookbooks. 

Its highly recommended to go through the offical training materials from Chef to get started on Windows. https://learn.chef.io/manage-a-node/windows/

Here is an example for simple LWRP Chef Recipe to launch an IIS site.

````
powershell_script 'Install IIS' do
  code 'Add-WindowsFeature Web-Server'
end
 
service 'w3svc' do
  action [:enable, :start]
end

template 'c:\inetpub\wwwroot\Default.htm' do
  source 'Default.htm.erb'
end
````

Each recipe is a collection of resources, and typically configures a software package or some piece of infrastructure. A cookbook groups together recipes and other information in a way that is more manageable than having just recipes alone.

For example the above recipe installs IIS, starts W3 service and drops a HTML file to the default website on Windows server. Each steps consists of a resource and action. In the first step chef uses PowerShell resource to add windows feature, next it uses Service resource (A LWRP wrapper) to start ther service and finally its uses a template resouce to copy a template file to wwwroot.

[Chef market place] (https://supermarket.chef.io/) and GitHub are the most common places to search for custom cookbooks.

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