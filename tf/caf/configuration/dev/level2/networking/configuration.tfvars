landingzone = {
  backend_type        = "azurerm"
  global_settings_key = "foundations"
  level               = "level2"
  key                 = "networking_hub"
  tfstates = {
    foundations = {
      level   = "lower"
      tfstate = "caf_foundations.tfstate"
    }
  }
}

resource_groups = {
  lb = {
    name = "example-lb"
  }
}

vnets = {
  vnet_test = {
    resource_group_key = "lb"
    vnet = {
      name          = "vnet-test"
      address_space = ["10.1.0.0/16"]
    }
    specialsubnets = {}
    subnets = {
      subnet1 = {
        name = "test-sn"
        cidr = ["10.1.1.0/24"]
      }
    }
  }
}

public_ip_addresses = {
  lb_pip = {
    name                    = "lb_pip1"
    resource_group_key      = "lb"
    sku                     = "Standard"
    allocation_method       = "Static"
    ip_version              = "IPv4"
    idle_timeout_in_minutes = "4"
  }
}

# Public Load Balancer will be created. For Internal/Private Load Balancer config, please refer 102-internal-load-balancer example.

load_balancers = {
  lb1 = {
    name                      = "lb-test"
    sku                       = "Standard"
    resource_group_key        = "lb"
    backend_address_pool_name = "web-app"

    frontend_ip_configurations = {
      config1 = {
        name                  = "config1"
        resource_group_key    = "lb"
        public_ip_address_key = "lb_pip"
      }
    }

    backend_address_pool_addresses = {
      address1 = {
        backend_address_pool_address_name = "address1"
        vnet_key                          = "vnet_test"
        ip_address                        = "10.1.1.1"
      }
    }

    probe = {
      resource_group_key = "lb"
      load_balancer_key  = "lb1"
      probe_name         = "probe1"
      port               = "22"

    }

    outbound_rules = {
      rule1 = {
        name                     = "outbound-rule"
        protocol                 = "Tcp"
        resource_group_key       = "lb"
        backend_address_pool_key = "pool1"
        frontend_ip_configuration = {
          config1 = {
            name = "config1"
          }
        }
      }
    }

    lb_rules = {
      rule1 = {
        resource_group_key             = "lb"
        load_balancer_key              = "lb1"
        lb_rule_name                   = "rule1"
        protocol                       = "tcp"
        frontend_port                  = "3389"
        backend_port                   = "3389"
        frontend_ip_configuration_name = "config1" #name must match the configuration that's defined in the load_balancers block.
      }
    }

  }
}

resource "azurerm_network_interface_backend_address_pool_association" "GTWYVM01" {
  network_interface_id    = "nic0"
  ip_configuration_name   = "lb_pip1"
  backend_address_pool_id = "address1"

  # depends_on = [azurerm_virtual_machine.GTWYVM01]
}


# Virtual machines
virtual_machines = {

  # Configuration to deploy a virtual machine
  vm1 = {
    resource_group_key                   = "lb"
    provision_vm_agent                   = true
    boot_diagnostics_storage_account_key = "bootdiag_region1"

    os_type = "windows"

    # the auto-generated ssh key in keyvault secret. Secret name being {VM name}-ssh-public and {VM name}-ssh-private
    keyvault_key = "vm_kv"

    # Define the number of networking cards to attach the virtual machine
    networking_interfaces = {
      nic0 = {
        # Value of the keys from networking.tfvars
        vnet_key                = "vnet_test"
        subnet_key              = "subnet1"
        name                    = "0"
        enable_ip_forwarding    = false
        internal_dns_name_label = "nic0"
      }
    }

    virtual_machine_settings = {
      windows = {
        name           = "gateway1"
        size           = "Standard_F2"
        admin_username = "adminuser"

        # Spot VM to save money
        priority        = "Spot"
        eviction_policy = "Deallocate"

        # Value of the nic keys to attach the VM. The first one in the list is the default nic
        network_interface_keys = ["nic0"]

        os_disk = {
          name                 = "gtw_vm1_os"
          caching              = "ReadWrite"
          storage_account_type = "Standard_LRS"
        }

        source_image_reference = {
          publisher = "MicrosoftWindowsServer"
          offer     = "WindowsServer"
          sku       = "2019-Datacenter"
          version   = "latest"
        }

      }
    }

  }
}

diagnostic_storage_accounts = {
  # Stores boot diagnostic for region1
  bootdiag_region1 = {
    name                     = "bootrg1"
    resource_group_key       = "lb"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Cool"
  }
}

keyvaults = {
  vm_kv = {
    name                = "vmsecrets"
    resource_group_key  = "lb"
    sku_name            = "standard"
    soft_delete_enabled = true
    creation_policies = {
      logged_in_user = {
        certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover"]
        secret_permissions      = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
  }
}


# resource_groups = {
#   vnet_hub_re1 = {
#     name   = "vnet-hub-re1"
#     region = "region1"
#   }
# }

# vnets = {
#   hub_re1 = {
#     resource_group_key = "vnet_hub_re1"
#     region             = "region1"
#     vnet = {
#       name          = "hub-re1"
#       address_space = ["100.64.100.0/22"]
#     }
#     specialsubnets = {
#       GatewaySubnet = {
#         name = "GatewaySubnet" #Must be called GateWaySubnet in order to host a Virtual Network Gateway
#         cidr = ["100.64.100.0/27"]
#       }
#       AzureFirewallSubnet = {
#         name = "AzureFirewallSubnet" #Must be called AzureFirewallSubnet
#         cidr = ["100.64.101.0/26"]
#       }
#     }
#     subnets = {
#       AzureBastionSubnet = {
#         name    = "AzureBastionSubnet" #Must be called AzureBastionSubnet
#         cidr    = ["100.64.101.64/26"]
#         nsg_key = "azure_bastion_nsg"
#       }
#       jumpbox = {
#         name    = "jumpbox"
#         cidr    = ["100.64.102.0/27"]
#         nsg_key = "jumpbox"
#       }
#       private_endpoints = {
#         name                                           = "private_endpoints"
#         cidr                                           = ["100.64.103.128/25"]
#         enforce_private_link_endpoint_network_policies = true
#       }
#     }
#   }

# }

# load_balancers = {
#   gtw_lb1 = {
#     name                      = "jumpbox-lb"
#     sku                       = "basic"
#     resource_group_key        = "vnet_hub_re1"
#     backend_address_pool_name = "web-gateway"

#     frontend_ip_configurations = {
#       config1 = {
#         name                          = "gtwlbfeconfig"
#         vnet_key                      = "hub_re1"
#         subnet_key                    = "jumpbox"
#         private_ip_address_allocation = "Dynamic"
#       }
#     }

#   }
# }
