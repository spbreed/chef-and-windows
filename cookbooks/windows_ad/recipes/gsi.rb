windows_ad_domain "gsi.com" do
  action :create
  type "forest"
  safe_mode_pass "100Un1c0rn"
  domain_user "adadmin"
  domain_pass "100Un1c0rn"
  net_bios_name "gsi"
end

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
             "pwd" => "100Un1c0rn"
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
             "pwd" => "100Un1c0rn"
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
             "pwd" => "100Un1c0rn"
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
             "pwd" => "100Un1c0rn"
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
             "pwd" => "100Un1c0rn"
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
             "pwd" => "100Un1c0rn"
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
             "pwd" => "100Un1c0rn"
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
             "pwd" => "100Un1c0rn"
           })
    end