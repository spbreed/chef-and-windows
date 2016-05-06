#
# Cookbook Name:: custom_ad
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
windows_ad_domain "gsi.com" do
  action :create
  type "forest"
  safe_mode_pass "password@123"
  domain_user "adadmin"
  domain_pass "password@123"
  net_bios_name "gsi"
end

#restart after
reboot 'now' do
  action :request_reboot
  reason 'Cannot continue Chef run without a reboot.'
end