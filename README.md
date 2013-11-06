Papyrus
========================================================================

Papyrus is an accessible content delivery and student management application. It was originally developed by Taras Danylak at York University Libraries. Its core purpose is to provide a delivery system for online books, articles and course kits to students with disabilities. Another prominent function of Papyrus is to keep track of and help manage student accessibility information, as well as act as a repository for electronic books, articles and course kits.

Deploying Papyrus
------------------

There are two ways to install and test out Papyrus. The first one lets you start up the server on your computer and check out the features in development mode. The second way requires the setup of Papyrus on a Linux server with a MySQL database and Ruby on Rails installed.

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

By default Papyrus comes with a Capistrano deployment file. If you are familiar with Capistrano and deployment to Apache/Passenger system, you can change the values and set up your server to be ready to deploy Papyrus.

In production you still have to run the following commands in order to set up the configuration files, database tables and default user data.

```
## ON THE PRODUCTION SERVER in papyrus directory
$ rake app:setup
## Follow Printed instructions to finish the setup
```

After the setup is finished and configuration options are changed, you can start using Papyrus.

Configuration Options
=====================


The configuration options are located in:

```
config/papyrus_app_config.rb
```
This is a simple RUBY configuration file that contains settings for the application's name, authentication, error handling and bibliographic search.

### Organization

| OPTION      | Description                                                        | Usage               |
|-------------|--------------------------------------------------------------------|---------------------|
| full_name   | The full name of your organization. i.e. York University Libraries | Used in copyright   |
| short_name  | Short name of your organization, i.e. yul                          | Used internally     |
| app_url     | The URL where Papyrus is deployed.                                 | Email notifications |

### Authentication

| OPTION                      | Description                                         | Usage                 |
|-----------------------------|-----------------------------------------------------|-----------------------|
| cas\_header\_name           | The name of the CAS header to authenticate the user | Authentication module |
| cas\_user\_id\_name       | The name of user id to be use. i.e Passport York    | User module           |
| after\_logout\_redirect\_to | The URL to redirect the user to after logout        | Logout function       |
| cookies_domain              | The domain to use for cookies                       | Not implemented yet   |


### Errors

| OPTION                 | Description                                                |
|------------------------|------------------------------------------------------------|
| email\_subject\_prefix | The prefix to use in the email subject                     |
| sender_address         | Address of the sender for error emails                     |
| error_recipients       | An array of email addresses to receive error notifications |

### Notifications

| OPTION                   | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| from_email               | The From email address to use when sending out notifications                |
| welcome_subject          | The subject for the welcome email                                           |
| notification_subject     | The subject for notifications email, when sending notifications to students |
| items\_assigned\_subject | The subject of items that have been assigned to you email                   |


### Bibliographic Search (bib search)

| OPTION                   | Description                                                       | Related to     |
|--------------------------|-------------------------------------------------------------------|----------------|
| type           | The type of bib search supported. Currently only 'solr' search is supported | solr, worldcat |
| label          | The label to use on the front end when searching.                           | any |
| id_prefix      | The prefix to use when storing the id of the item in database               | any |
| url            | The URL of the bib search server (i.e. Solr/VuFind)                         | any |
| query_fields   | The list of fields to query and when searching for items                    | SOLR |
| phrase_fields  | The list of phrase fields to search with the boost assigned                 | SOLR |
| boost_function | Custom boost function for                                                   | SOLR |
| sort           | How to sort search results                                                  | SOLR |
