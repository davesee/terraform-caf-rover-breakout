./rover.sh -lz tf/caf/landingzones/landingzones/caf_launchpad -launchpad -var-folder ../../../configuration/dev/level0 -level level0 -env test -a apply

./rover.sh -lz tf/caf/landingzones/landingzones/caf_foundations -var-folder ../../../configuration/dev/level1 -level level1 -env test -a apply

./rover.sh -lz tf/caf/landingzones/landingzones/caf_networking -var-folder ../../../configuration/dev/level2/networking -level level2 -env test -a apply
./rover.sh -lz tf/caf/landingzones/landingzones/caf_shared_services -var-folder ../../../configuration/dev/level2/shared_services -level level2 -env test -a apply
