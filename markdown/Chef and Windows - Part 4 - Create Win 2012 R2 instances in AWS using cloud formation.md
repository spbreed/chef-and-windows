In typical scenarios provisioning windows servers are not part of Chef coobook receipes. Tool like vagrant, packer, cloud formation (AWS), ARM templates (Azure) is used to provision windows instances.
Lets consider deploying to AWS. CloudFormation is a free service that provides the toolsets to create and manage the infrastructure resources from almost all AWS services. A cloud formation template is a declarative JSON file which defines AWS resources. Advantage of using CF template is when it is submitted to Cloud formation service, it creates all the resources and dependenices in the right order to form a "Stack". When the CF template is updated in the future, all the dependent resources across the stack is updated automatically. This enables the admins to build and tear environments with minimal footprints and dependencies at a rapid pace.

![Architecture](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image002.png)

AWS provides nifty UI tool to edit and validate the CF templates online. Attached video is a good starting point to cloud formation.
https://www.youtube.com/watch?v=fVMlxJJNmyA

A typical cloud formation template consists 
- Parameters
    - User input values. (Eg: Security groups, Username, passwords etc)
- Resources
    - AWS resources which needs to be created (Eg: Instances, VPC, EIP, Load balancers, S3 etc)
- Mapping
    - Helper values to drive paramters and resources 
- Output
    - Resource outputs after creation (Eg: Instance name, Public IP's etc)
    
![Architecture](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image003.png)


This series covers installing Active Directory, SQL server 2014 and SharePoint 2016 on a Win 2012 server using Chef. Before getting in to Chef, A windows 2012 instance needs to be provisioned with below specs

- Latest stable Win 2012 R2 bits
- Dedicated drives for SQL data and logs
- Public IP
- WinRM enabled
- Firewall changes to contact with Chef server
- Deployed to assigned Subnet

To design this scenario in AWS, an EC2 instance and Elastic IP is required

![Architecture](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image004.png)

Ec2 instance needs to be configured with
    - Additional volunes for SQL and Logs
    - Configured with user provided password
    - WinRM ports 5896,5895 are open
    - Provisioned in to a already existing subnet
    - Assigned with already existing security groups

Static elastic IP associated with Ec2 instance.

![Architecture](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image006.png)

![Architecture](http://www.devopsrocks.com/mywbblog/wp-content/uploads/2016/04/image008.png)


````json
		 {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Parameters": {
    "KeyName": {
      "Description": "Name of an existing EC2 KeyPair",
      "Type": "AWS::EC2::KeyPair::KeyName",
      "ConstraintDescription": "must be the name of an existing EC2 KeyPair."
    },
    "InstanceType": {
      "Description": "Amazon EC2 instance type",
      "Type": "String",
      "Default": "m3.large",
      "AllowedValues": [
        "t1.micro",
        "t2.micro",
        "t2.small",
        "t2.medium",
        "m1.small",
        "m1.medium",
        "m1.large",
        "m1.xlarge",
        "m2.xlarge",
        "m2.2xlarge",
        "m2.4xlarge",
        "m3.medium",
        "m3.large",
        "m3.xlarge",
        "m3.2xlarge"
      ],
      "ConstraintDescription": "must be a valid EC2 instance type."
    },
    "SubnetId": {
      "Type": "String",
      "Description": "SubnetId of an existing subnet in your Virtual Private Cloud (VPC)"
    },
    "AmiId": {
      "Type": "String",
      "Description": "AMI You want to use"
    },
    "SecurityGroupId": {
      "Type": "String",
      "Description": "SecurityGroup to use"
    }
  },
  "Metadata": {
    "AWS::CloudFormation::Designer": {
      "d4d822ac-5db2-4d13-974b-03f9c0df2fdd": {
        "size": {
          "width": 60,
          "height": 60
        },
        "position": {
          "x": 350,
          "y": 110
        },
        "z": 1,
        "embeds": []
      },
      "fc175dd7-56d3-49a6-8be7-2aebb263ba57": {
        "size": {
          "width": 60,
          "height": 60
        },
        "position": {
          "x": 600,
          "y": 120
        },
        "z": 1,
        "embeds": [],
        "isconnectedto": [
          "d4d822ac-5db2-4d13-974b-03f9c0df2fdd"
        ]
      },
      "3cbd2586-808f-43b3-b268-6c6c363855b4": {
        "size": {
          "width": 60,
          "height": 60
        },
        "position": {
          "x": 190,
          "y": 110
        },
        "z": 1,
        "embeds": [],
        "isconnectedto": [
          "d4d822ac-5db2-4d13-974b-03f9c0df2fdd"
        ]
      },
      "447fdafa-54bb-46a8-8b87-f5734f1fb05a": {
        "source": {
          "id": "3cbd2586-808f-43b3-b268-6c6c363855b4"
        },
        "target": {
          "id": "d4d822ac-5db2-4d13-974b-03f9c0df2fdd"
        },
        "z": 1
      }
    }
  },
  "Resources": {
    "WINServer2012R2": {
      "Type": "AWS::EC2::Instance",
      "Metadata": {
        "AWS::CloudFormation::Init": {
          "config": {
            "files": {
              "c:\\cfn\\hooks.d\\renamedrivesandresetpassword.ps1": {
                "content": {
                  "Fn::Join": [
                    "",
                    [
                      "# Mount and rename drives properly\n",
                      "New-EventLog -LogName Application -Source 'AWS Startup'\n",
                      "Write-EventLog -LogName Application -Source 'AWS Startup' -EntryType Information -EventID 1 -Message 'PowerShell begin.'\n",
                      "$edrive = Get-WmiObject -Class win32_volume -Filter \"DriveLetter = 'E:'\"\n",
                      "$edrive.Label = \"SQL\"\n",
                      "$edrive.DriveLetter= \"F:\"\n",
                      "$edrive.put()\n",
                      "$ddrive = Get-WmiObject -Class win32_volume -Filter \"DriveLetter = 'D:'\"\n",
                      "$ddrive.Label = \"Logs\"\n",
                      "$ddrive.DriveLetter= \"E:\"\n",
                      "$ddrive.put()\n",
                      "Write-EventLog -LogName Application -Source 'AWS Startup' -EntryType Information -EventID 1 -Message 'Drive Changes complete'\n",
                      "$admin = [adsi]('WinNT://./administrator, user')\n",
                      "$admin.psbase.invoke('SetPassword', 'password@123')\n",
                      "Write-EventLog -LogName Application -Source 'AWS Startup' -EntryType Information -EventID 1 -Message 'Password chanage complete.'\n",
                      "netsh advfirewall firewall add rule name=\"WinRM 5985\" protocol=TCP dir=in localport=5985 action=allow\n",
                      "netsh advfirewall firewall add rule name=\"WinRM 5986\" protocol=TCP dir=in localport=5986 action=allow\n",
                      "Write-EventLog -LogName Application -Source 'AWS Startup' -EntryType Information -EventID 1 -Message 'Firewall changes complete.'\n",
                      "winrm quickconfig -q\n",
                      "winrm set winrm/config '@{MaxTimeoutms=\"1800000\"}'\n",
                      "winrm set winrm/config/service '@{AllowUnencrypted=\"true\"}'\n",
                      "winrm set winrm/config/service/auth '@{Basic=\"true\"}'\n",
                      "Write-EventLog -LogName Application -Source 'AWS Startup' -EntryType Information -EventID 1 -Message 'Winrm changes complete.'\n"
                    ]
                  ]
                }
              }
            },
            "commands": {
              "1.1-rename_drives": {
                "command": "powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -File c:\\cfn\\hooks.d\\renamedrivesandresetpassword.ps1",
                "waitAfterCompletion": "0"
              }
            },
            "services": {
              "windows": {
                "cfn-hup": {
                  "enabled": "true",
                  "ensureRunning": "true",
                  "files": [
                    "c:\\cfn\\hooks.d\\renamedrivesandresetpassword.ps1"
                  ]
                }
              }
            }
          }
        },
        "AWS::CloudFormation::Designer": {
          "id": "d4d822ac-5db2-4d13-974b-03f9c0df2fdd"
        }
      },
      "Properties": {
        "ImageId": {
          "Ref": "AmiId"
        },
        "Tags": [
          {
            "Key": "Name",
            "Value": "GSI-SP2016"
          }
        ],
        "InstanceType": {
          "Ref": "InstanceType"
        },
        "SecurityGroupIds": [
          {
            "Ref": "SecurityGroupId"
          }
        ],
        "SubnetId": {
          "Ref": "SubnetId"
        },
        "KeyName": {
          "Ref": "KeyName"
        },
        "BlockDeviceMappings": [
          {
            "DeviceName": "/dev/sda1",
            "Ebs": {
              "VolumeSize": "60"
            }
          },
          {
            "DeviceName": "xvdc",
            "Ebs": {
              "VolumeSize": "50"
            }
          },
          {
            "DeviceName": "xvdd",
            "Ebs": {
              "VolumeSize": "50"
            }
          }
        ],
        "UserData": {
          "Fn::Base64": {
            "Fn::Join": [
              "",
              [
                "<script>\n",
                "cfn-init.exe -v -s ",
                {
                  "Ref": "AWS::StackId"
                },
                " -r WINServer2012R2",
                " --region ",
                {
                  "Ref": "AWS::Region"
                },
                "\n",
                "</script>"
              ]
            ]
          }
        }
      }
    },
    "WINServerIP": {
      "Type": "AWS::EC2::EIP",
      "Properties": {
        "InstanceId": {
          "Ref": "WINServer2012R2"
        },
        "Domain": "vpc"
      },
      "Metadata": {
        "AWS::CloudFormation::Designer": {
          "id": "3cbd2586-808f-43b3-b268-6c6c363855b4"
        }
      }
    },
    "WINServerIPAssoc": {
      "Type": "AWS::EC2::EIPAssociation",
      "Properties": {
        "InstanceId": {
          "Ref": "WINServer2012R2"
        },
        "AllocationId": {
          "Fn::GetAtt": [
            "WINServerIP",
            "AllocationId"
          ]
        }
      },
      "Metadata": {
        "AWS::CloudFormation::Designer": {
          "id": "447fdafa-54bb-46a8-8b87-f5734f1fb05a"
        }
      }
    }
  },
  "Outputs": {
    "InstanceId": {
      "Value": {
        "Ref": "WINServer2012R2"
      },
      "Description": "Instance Id of newly created instance"
    },
    "Subnet": {
      "Value": {
        "Ref": "SubnetId"
      },
      "Description": "Subnet of instance"
    },
    "EIP": {
      "Value": {
        "Ref": "WINServerIP"
      },
      "Description": "Elastic IP of the instance"
    },
    "SecurityGroupId": {
      "Value": {
        "Ref": "SecurityGroupId"
      },
      "Description": "Security Group of instance"
    }
  }
}
  ````
  
  After instance create event, 'cfn-init.exe' utility in "UserData" section executes "AWS::CloudFormation::Init" section to configure the instance with custom settings.
  
  Wait few minutes till AWS cloud formation does its magic and creates a new stack. Now make a note of elastic IP from Output section and RDP in to the machine to verify all the settings provisioned using CF template.
  
  Now to make sure the server is accessible, WIMRM ports are working as expected run the below script
  
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

  
  

   