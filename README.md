[![Build Status](https://travis-ci.org/yorkulcs/papyrus.svg?branch=master)](https://travis-ci.org/yorkulcs/papyrus)

Papyrus
========================================================================

Papyrus is an accessible content delivery and student management application. It was originally developed by Taras Danylak at York University Libraries. Its core purpose is to provide a delivery system for online books, articles and course kits to students with disabilities. Another prominent function of Papyrus is to keep track of and help manage student accessibility information, as well as act as a repository for electronic books, articles and course kits.

Downloading The Latest Version
------------------------------

The latest Papyrus version can be found by clicking on the [Releases](https://github.com/yorkulcs/papyrus/releases) link at the top of this page. Currently v2.7 is the most recent production ready version.

Checkout the [Wiki Pages](https://github.com/yorkulcs/papyrus/wiki) for more details on how to deploy Papyrus.

Demo
----

Clone the master branch of Papyrus into a directory on your computer. Demo version of Papyrus can be run via a Vagrant box, so you will need to download and install [Vagrant](https://www.vagrantup.com). You must use Vagrant 1.8.1 or newer for synced folder to work properly. 

Once vagrant is installed, cd into the papyrus directory and type:

```sh
papyrus$ vagrant up
papyrus$ vagrant ssh
```
Because rails 4.2.x changed the way rails server binds to a network interface, in order for you to be able to access Papyrus running in the vagrant box you must start the server and bind it to 0.0.0.0 address:

```sh
papyrus$ rails server -b 0.0.0.0
# or user an alias created for this purpose
papyrus$ rs
```
An admin user was created for the purpose of this demo, Papyrus will automatically log you in as that user. 
This should start up a demo Papyrus server. You can go to (http://localhost:3000) in your browser to test out Papyrus. 

Deploying Papyrus
------------------

There are two ways to install and test out Papyrus. The first one lets you start up the server on your computer and check out the features in development mode. The second way requires the setup of Papyrus on a Linux server with a MySQL database and Ruby on Rails installed.

Prerequisites
-------------

- Ruby 2.0.0
- Rails 4.2.x
- MySQL 5.5 or PostgreSQL (This method requires changing of the configuration files)
- SQLite (For development/testing mode)

Installing
----------

To install Papyrus, you must first download the source code via a git clone mechanism.

```sh
$ cd directory/where/papyrus/will/live
$ git clone git://github.com/yorkulcs/papyrus.git
```

Development Mode
----------------

After Papyrus source code has been cloned onto your system, you can run the setup tasks and follow that immediately by running Papyrus in development mode.

To run Papyrus in the development mode:

```sh
$ cd papyrus
$ bundle
$ rake app:setup
## after the setup has copied the files
$ rake db:migrate
## setup default development data
$ rake db:populate
$ rails s
```

The last command will run the Rails development server which will load the application.
You can access this application by going to [http://localhost:3000/login](http://localhost:3000/login).


Production Mode
---------------

Checkout this guide on how to setup Papyrus in production.

[Setup Papyrus in Production](https://github.com/yorkulcs/papyrus/wiki/Setup-Papyrus-in-Production)

Configuration Options
=====================

Configuration is done inside of Papyrus instance. 
