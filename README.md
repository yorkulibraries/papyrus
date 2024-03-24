
Papyrus
========================================================================

Papyrus is an accessible content delivery and student management application. Its core purpose is to provide a delivery system for online books, articles and course kits to students with disabilities. Another prominent function of Papyrus is to keep track of and help manage student accessibility information, as well as act as a repository for electronic books, articles and course kits.

## Getting started

```
git clone https://github.com/yorkulibraries/papyrus.git
cd papyrus
docker compose up --build
```

There are 3 containers created: **web**, **db** and **mailcatcher**

# Access the front end web app in DEVELOPMENT 

(http://localhost:3005/)


By default, the application will listen on port 3005 and runs with RAILS_ENV=development.

To access the application in Chrome browser, you will need to add the ModHeader extension to your Chrome browser.

Header: PYORK_USER
Value: admin (or manager or whatever user you want to mimic)

For convenience, you can import the ModHeader profile from the included ModHeader_admin.json. 

# Access mailcatcher web app

(http://localhost:3085/)


# What if I want to use a different port?

If you wish to use a different port, you can set the PORT environment or change PORT in .env file.

```
PORT=4005 docker compose up --build
```

# Run tests

Start the containers if you haven't started them yet.

```
docker compose up --build
```

Run all the tests

```
docker compose exec web rt 
```

Run a specific test
```
docker compose exec web rt test/controllers/users_controller_test.rb
```

# Access the containers

DB container
```
docker compose exec db bash
```

Webapp container
```
docker compose exec web bash
```


## Authentication configuration

Values available for "is_authentication_method" are "devise" (login and pw), "header" (only yorku setup). Currently "header" is by default on "config/application.rb". You can use AUTH_METHOD env to change devise as authentication mode.

```
AUTH_METHOD=devise docker compose up --build
```

## Importing students from CSV

Prepare the CSV file similar to the lines below:

```
student_no,firstname,lastname,studentemail,counsellorname,counselloremail,Date consent form signed,Access to Library Accessible Lab,Book retrieval from stacks,Alternate Format Transcription,PDF,Large Print,Daisy Audio,Braille,Word,Other (specify),Other (Please do not exceed 160 characters):,Additional Information
"987654321","Test","Tester","student1@mailinator.com","Ads, Katherine","co1@mailinator.com","Oct 24 2014  9:05AM","True","True","True","True","","","True","","","","This is additional information"
"999999999","test","test","student2@mailinator.com","DSS, Judith","co2@mailinator.com","Oct  2 2014  3:48PM","True","True","True","True","True","True","True","True","True","mp3",""
"111222333","John","Smith","student3@mailinator.com","Done, Sean","co3@mailinator.com","Oct 27 2014  2:07PM","","","True","True","","","","","","","Student requires 16 point font or larger"
```

Find the user ID of the Coordinator from the Papyrus Users screen and enter in the command below.

Suppose the Coordinator ID is 2 and the user running this command ID is 1.

```
docker compose exec web bundle exec rake import:students COORDINATOR_ID=2 CREATOR_ID=1 EMAIL_REPORT_LOG_TO=me@me.ca FILE=/path/to/students.csv
```

## Deactivating students

```
docker compose exec web bundle exec rake utils:deactivate_students
```
