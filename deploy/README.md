# Kolla-ansible Workshop Deployment

This utility is to enable individual student environments to be created and destroyed easily using Terraform.

## Student Environment

Defaults  

  * 3 - controller nodes
  * 2 - compute nodes (1x 15GB volume each)
  * 1 - floating IP
  * 1 - control-network
  * 1 - compute-network
  * 1 - attachment to public network

## Configuration

Options such as node count, private key path or instance size can be configured in the `terraform.tfvars` file.

## Usage

The `deploy.sh` script is used to specify an action (create or destroy), and a starting and ending index (0 10). 
The optional fourth command is the operating system (ubuntu or centos).

### Examples

#### Create 5 ubuntu environments for stundent0 thru student4

```
./deploy.sh create 0 4
```

#### Create 5 centos environments for student5 thru student9
```
./deploy.sh create 5 9 centos
```

#### Destroy environments 0 thru 9
```
./deploy.sh destroy 0 9
```

## Account info

The `student-info` file contains a log of accounts created including Id (e.g. student0), server IP, user and password.

## Troubleshooting

Each student environment is maintained in a Terraform state file located in the `state` dir and named `studentN` where N 
is the index of the student environment. To troubleshoot an individual environment, pass the -state flag to terraform 
referencing the path to the state file you want to work with (e.g. terraform show -state state/student0).  Be aware that 
the state files will remain even after you have destroyed the environment (they can be deleted at that time tho).

### Starting over with deploy.sh

Unless things have gone terribly wrong, you should be able to delete your entire environment with one command that covers 
all indexes. For a range of 0 to 20 students, you could execute the following:
```
./deploy.sh destroy 0 20
``` 

### Starting over manually

To manually cleanup the environment, use Horizon (or other tool) to completely remove all created instances. 
After that, remove all the studentN files in the `state` directory.
