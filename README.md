Papyrus
========================================================================

Papyrus is an  Accessible Content Delivery and Student Management Application. It was originally developed by Taras Danylak at York University's Library. It's core purpose is to provide a delivery system for online books, articles and course kits to students with disablities. Another prominent function of Papyrus is to keep track and help manage student accessiblity information, as well as act as a repository for electronic books, articles and course kits.

Deploying Papyrus 
------------------

There are two ways to install and test out Papyrus. First one lets you start up the server on your computer and checkout the features in development mode. The second way requires the setup of Papyrus on a Linux Server with a MySQL database and Ruby on Rails installed.

Prerequisites
-------------

- Ruby 1.9.3
- Rails 3.2.x
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

After Papyrus source code has been cloned onto your system. You can run the setup tasks and follow that immediatelly by running Papyrus in development mode.

To run Papyrus in the development mode:

```sh
$ cd papyrus
$ rake app:setup
## after the setup has copied the files
$ rake db:migrate
## setup default development data
$ rake db:populate
$ rails s
```

The last command with run the Rails development server which will load the application. 
You can access this application by going to [http://localhost:3000/login](http://localhost:3000/login).


Production Mode
---------------

By default Papyrus comes with Capistrano deployment file. If you are familiar with Capistrano and deployment to Apache/Passenger system, you can change the values and setup your server to be ready to deploy Papyrus.

In production you still have to run the following commands in order to setup the configuration files, database tables and default user data.

``` 
## ON THE PRODUCTION SERVER in papyrus directory
$ rake app:setup
## Follow Printed instructions to finish the setup
```

After the setup is finished and configuration options are changed, you can start using Papyrus.

Configuration Options
=====================

