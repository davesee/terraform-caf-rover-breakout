## Azure CAF Rover Unboxed
Run the following commands using your Linux shell from the root of the project. Modules are locally referenced for ease of use and rapid testing.

### Level 0 - Landing Zone Launchpad
```
./rover.sh -lz tf/caf/landingzones/landingzones/caf_launchpad \
    -launchpad \
    -var-folder ../../../configuration/dev/level0 \
    -level level0 \
    -env test \
    -a apply
```

### Level 1 - Foundations Landing Zone
```
./rover.sh -lz tf/caf/landingzones/landingzones/caf_foundations \
    -var-folder ../../../configuration/dev/level1 \
    -level level1 \
    -env test \
    -a apply
```

### Level 0 - Networking and Shared Services Landing Zones
```
./rover.sh -lz tf/caf/landingzones/landingzones/caf_networking \
    -var-folder ../../../configuration/dev/level2/networking \
    -level level2 \
    -env test \
    -a apply

./rover.sh -lz tf/caf/landingzones/landingzones/caf_shared_services \
    -var-folder ../../../configuration/dev/level2/shared_services \
    -level level2 \
    -env test \
    -a apply
```

## Resources
[Configurations](https://github.com/Azure/caf-terraform-landingzones-starter)   
[Landing Zones](https://github.com/Azure/caf-terraform-landingzones)   
[Modules](https://github.com/aztfmod/terraform-azurerm-caf)   
[Modules Naming Provider](https://github.com/aztfmod/terraform-provider-azurecaf)   
[Rover](https://github.com/aztfmod/rover)   
