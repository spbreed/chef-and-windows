#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_ad
# Recipe:: contoso
# 
# Copyright 2013, Texas A&M
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# Create user "ad admin" in the Users OU
    windows_ad_user "Ad Admin" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "adadmin",
             "upn" => "adadmin@gsi.com",
             "fn" => "ad",
             "ln" => "admin",
             "display" => "Admin, Ad",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end

# Create user "SQL" in the Users OU
    windows_ad_user "Sql Service" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "sqlservice",
             "upn" => "sqlservice@gsi.com",
             "fn" => "sql",
             "ln" => "service",
             "display" => "Service, Sql",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
  # Create user "SP admin" in the Users OU
    windows_ad_user "SP Admin" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "spadmin",
             "upn" => "spadmin@gsi.com",
             "fn" => "sp",
             "ln" => "admin",
             "display" => "Admin, SP",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
      # Create user "SP farm" in the Users OU
    windows_ad_user "SP Farm" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "spfarm",
             "upn" => "spfarm@gsi.com",
             "fn" => "sp",
             "ln" => "farm",
             "display" => "Farm, SP",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
      # Create user "SP service" in the Users OU
    windows_ad_user "SP Service" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "spservice",
             "upn" => "spservice@gsi.com",
             "fn" => "sp",
             "ln" => "service",
             "display" => "Service, SP",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
        # Create user "SP crawl" in the Users OU
    windows_ad_user "SP Crawl" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "spcrawl",
             "upn" => "spcrawl@gsi.com",
             "fn" => "sp",
             "ln" => "crawl",
             "display" => "Crawl, SP",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
        # Create user "SP apppool" in the Users OU
    windows_ad_user "SP AppPool" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "spapppool",
             "upn" => "spapppool@gsi.com",
             "fn" => "sp",
             "ln" => "apppool",
             "display" => "AppPool, SP",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
    # Create user "sql admin" in the Users OU
    windows_ad_user "sql admin" do
      action :create
      domain_name "gsi.com"
      ou "users"
      options ({ "samid" => "sqladmin",
             "upn" => "sqladmin@gsi.com",
             "fn" => "sql",
             "ln" => "admin",
             "display" => "admin, sql",
             "disabled" => "no",
             "pwd" => "password@123"
           })
    end
    
    # Add sql admin to admin group for RDP and local admin access
    windows_ad_group_member 'sql admin' do
        action :add
        group_name  'Enterprise Admins'
        domain_name 'gsi.com'
        user_ou 'Users'
        group_ou 'Users'
   end
   
   windows_ad_group_member 'ad admin' do
        action :add
        group_name  'Enterprise Admins'
        domain_name 'gsi.com'
        user_ou 'Users'
        group_ou 'Users'
   end
   
    windows_ad_group_member 'sp admin' do
        action :add
        group_name  'Enterprise Admins'
        domain_name 'gsi.com'
        user_ou 'Users'
        group_ou 'Users'
   end
   
    windows_ad_group_member 'sp farm' do
        action :add
        group_name  'Enterprise Admins'
        domain_name 'gsi.com'
        user_ou 'Users'
        group_ou 'Users'
   end