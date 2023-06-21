# Docker Image for launching slurm jobs
This image will contain a slurm node (and its controller), with the drmaa lib installed.

## Configuring the slurm node
The following environment variables are available: 
``` 
MAX_CPUS: '1' #  Max number of core allocated to the compute node
MAX_RAM: '4000' # Max memory (in Mo) allocated to the compute node
```

## Using DRMAA
To use DRMAA, you need to pay attention to several things:

#### DRMAA user
Jobs will probably need to be launched by a user known by the scheduler. You will need to use the following options to configure this: 
``` 
UID: the uid of the user GID: the gid of the user 
RUN_USER: the username of the user 
RUN_GROUP: the group of the user 
OTHER_GID: list of supplementary gid (comma separated) which the user is also a member of 
OTHER_RUN_GROUP: list of supplementary group (comma separated) which the user is also a member of. The order must match the order used for OTHER_GID. ```
```
