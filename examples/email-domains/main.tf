module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "regions" {
  source  = "codectl/locations/azure"
  version = "~> 1.0"

  location = {
    primary = "westeurope"
  }
}

module "rg" {
  source  = "codectl/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = module.regions.location.primary.name
    }
  }
}

module "acs" {
  source  = "codectl/acs/azure"
  version = "~> 1.0"

  communication = {
    name                = module.naming.communication_service.name_unique
    resource_group_name = module.rg.groups.demo.name

    email = {
      main = {
        name = "${module.naming.communication_service.name_unique}-email"

        domains = {
          managed = {
            name              = "AzureManagedDomain"
            domain_management = "AzureManaged"
          }
        }
      }
    }
  }
}
