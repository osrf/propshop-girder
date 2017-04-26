## The PropShop (Girder-based) ##

This repository deployes on AWS a
[Girder](https://girder.readthedocs.io/en/latest/) application for storing
simulation assets. Check it out [here](https://data.ignitionfuel.org).

## Prerequisites

You need an AWS account. Create an account [here](https://aws.amazon.com/) if
you do not have it.

# Architecture

We're going to spin-up one EC2 machine for hosting the Mongo database. In
addition, we'll use Amazon Elastic Beanstalk (EB) for deploying the Girder
server. In reality, we'll configure EB for using a load balancer. Depending on
the load, the load balancer can decide to scale our application by launching
more Girder instances in multiple EC2 servers.

This configuration is considered stateless, so the data needs to live outside
of the Girder instances. That's the reason for having our separate EC2 machine
hosting the Mongo database. Each of the Girder instances should point to the
external Mongo database.

# Setup your EC2 Mongo database.

* Sign in to the AWS console and browse to `Services`->`Compute`->`EC2`
* Click on the `Launch Instance` button. Then, follow the quick start wizard
  for configuring your machine
* Select an Ubuntu Server LTS distribution (e.g.: Ubuntu 16.04 LTS)
* Select your instance type (`t2.micro` is a good option for testing)
* Click on the `Next: Configure Instance Details` for tweaking your
  configuration
* Click on `6.Configure Security Group` in the top menu. This step allows you
  to configure the firewall rules that control the traffic for your instance.
  We're insterested in opening the port 22 TCP (SSH) and 27017 (MongoDB).
  Select `SSH`, `TCP protocol`, port 22 and `0.0.0.0/0` for allowing SSH from
  any machine. Click on `Add Rule` and select `Custom TCP rule`, `TCP`, 27017
  port and `0.0.0.0/0` for now. *Warning: With this configuration your MongoDB
  is publicly available without any authentication. We'll change this after
  configuring and launching your Girder instance via Elastic Beanstalk*
* Click on `Review and launch`->`Launch`
* A new window will pop-up associate a key pair to your instance. Create a new
  one or choose an existing one
* Click on `Launch instances` and save the `.pem` file in a folder with the
  rest of your keys (e.g. ~/keys). The permissions of the directory have to be
  `drwx------` and your key's permissions needs to be `-rw-------`
* Once your instance is up and running, log in:

      ssh -i ~/keys/<your_key_file.pem> ec2-user@<your_public_ip>

  Replace `<your_key_file.pem>` with the name of the `.pem` that you downloaded
  and `<your_public_ip>` with the public IP address of your running instance.
  Go to `Services`->`Compute`->`EC2`, click on `Running instances` and select
  your recently created instance. You should see in the property windows a field
  name `IPv4 Public IP` with the IP address. It's also a good idea to set a name
  for your instance if you don't have it yet.
* Install the Mongo database server:

     sudo apt-get install mongodb


* Logout, and test that you can connect to your remote instance. First of all,
  install the Mongo client app:

    sudo apt-get install mongodb-clients

* And verify your connection with the remote instance:

    mongo <your_public_ip>

  Replace `<your_public_ip>` with the public IP address of your running
  instance. *Note that this step should stop working when we secure the 27017
  port on your instance.*

## Automatically deploy to Elastic Beanstalk

The branch `production` is automatically deployed when new commits are pushed
in this branch.

