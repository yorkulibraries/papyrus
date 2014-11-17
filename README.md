Papyrus
========================================================================

Papyrus is an accessible content delivery and student management application. It was originally developed by Taras Danylak at York University Libraries. Its core purpose is to provide a delivery system for online books, articles and course kits to students with disabilities. Another prominent function of Papyrus is to keep track of and help manage student accessibility information, as well as act as a repository for electronic books, articles and course kits.

Downloading The Latest Version
------------------------------

The latest Papyrus version can be found by clicking on the [Releases](https://github.com/yorkulcs/papyrus/releases) link at the top of this page. Currently v2.3.2 is the most recent production ready version.

[Download v2.3.2 Zip File](https://github.com/yorkulcs/papyrus/archive/v2.3.2.tar.gz)

Checkout the [Wiki Pages](https://github.com/yorkulcs/papyrus/wiki) for more details on how to deploy Papyrus.

Demo
----

You can checkout a demo of Papyrus. [Papyrus Demo](http://demos.library.yorku.ca/papyrus/)

Username: demo
Password: demo

Please report abuse of the demo instance [here](https://github.com/yorkulcs/papyrus/issues)

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

Checkout this guide on how to setup Papyrus in production.

[Setup Papyrus in Production](https://github.com/yorkulcs/papyrus/wiki/Setup-Papyrus-in-Production)

Configuration Options
=====================


The configuration options are located in:

```
config/papyrus_app_config.rb
```
This is a simple RUBY configuration file that contains settings for the application's name, authentication, error handling and bibliographic search.

### Organization

| OPTION                    | Description                                                        | Usage               |
|---------------------------|--------------------------------------------------------------------|---------------------|
| full_name                 | The full name of your organization. i.e. York University Libraries | Used in copyright   |
| short_name                | Short name of your organization, i.e. yul                          | Used internally     |
| app_url                   | The URL where Papyrus is deployed.                                 | Email notifications |
| course\_code\_sample      | The format for a course to shown as a hint on courses page.        | Courses and Terms   |
| course\_code\_lookup_link | A link where to find the proper course code												 | Courses and Terms   |
| item_sources              | An array of sources for the electronic files of an Item            | Adding new Item     |

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


### Version 2.2 - Bibliographic Search (bib search)
> NOTE: Version 2.2 introduces Worldcat Search as an alternative to SOLR for looking up Bib Information for items. This requires a minor change in configuration to accomodate Worldcat and SOLR options.

###### SOLR

| OPTION              | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| solr.label          | The label to use on the front end when searching. (VuFind)                  |
| solr.id_prefix      | The prefix to use when storing the id of the item in the database           |
| solr.url            | The URL of the bib search server (i.e. Solr/VuFind)                         |
| solr.query_fields   | The list of fields to query and when searching for items                    |
| solr.phrase_fields  | The list of phrase fields to search with the boost assigned                 |
| solr.boost_function | Custom boost function for                                                   |
| solr.sort           | How to sort search results                                                  |

###### Worldcat
> NOTE: Worldcat integration requires an API key. If you're instution subscribes to OCLC services, you should already have an api key.

| OPTION             | Description (Defaults)                                                       |
|--------------------|------------------------------------------------------------------------------|
| worldcat.label     | The label to use on the front end when searching (Worldcat Search)           |
| worldcat.id_prefix | The prefix to sue when saving the id of the item in the database  (oclc)     |
| worldcat.key       | To access Worldcat you need an API key. Put the key here. (no key provided)  |


#### Version. 2.1 - Bibliographic Search (bib search)

>  NOTE:  There was a configuration change for bib search section. Solr specific configuration now lives under solr. prefix. Ensure you update you config if you pull the latest code.

| OPTION              | Description                                                                 | Related to     |
|---------------------|-----------------------------------------------------------------------------|----------------|
| type                | The type of bib search supported. Currently only 'solr' search is supported | solr |
| label               | The label to use on the front end when searching.                           | any  |
| id_prefix           | The prefix to use when storing the id of the item in database               | any  |
| solr.url            | The URL of the bib search server (i.e. Solr/VuFind)                         | SOLR |
| solr.query_fields   | The list of fields to query and when searching for items                    | SOLR |
| solr.phrase_fields  | The list of phrase fields to search with the boost assigned                 | SOLR |
| solr.boost_function | Custom boost function for                                                   | SOLR |
| solr.sort           | How to sort search results                                                  | SOLR |
