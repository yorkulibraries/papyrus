
Papyrus
========================================================================

Papyrus is an accessible content delivery and student management application. It was originally developed by Taras Danylak at York University Libraries. Its core purpose is to provide a delivery system for online books, articles and course kits to students with disabilities. Another prominent function of Papyrus is to keep track of and help manage student accessibility information, as well as act as a repository for electronic books, articles and course kits.

## Getting started
Take a look at [Vagrant Papyrus](https://github.com/yorkulibraries/vagrant-papyrus) to quickly deploy an instance of Papyrus.

## Importing students from CSV

Prepare the CSV file similar to the lines below:

```
student_no,firstname,lastname,studentemail,counsellorname,counselloremail,Date consent form signed,Access to Library Accessible Lab,Book retrieval from stacks,Alternate Format Transcription,PDF,Large Print,Daisy Audio,Braille,Word,Other (specify),Other (Please do not exceed 160 characters):,Additional Information
"987654321","Test","Tester","testtester@yorku.ca","Ads, Katherine","ads@tss.test.ca","Oct 24 2014  9:05AM","True","True","True","True","","","True","","","","This is additional information"
"999999999","test","test","test_test@gmail.com","DSS, Judith","dss@test.ca","Oct  2 2014  3:48PM","True","True","True","True","True","True","True","True","True","mp3",""
"111222333","John","Smith","John_Smith@aol.com","Done, Sean","d@tes.ca","Oct 27 2014  2:07PM","","","True","True","","","","","","","Student requires 16 point font or larger"
```

Find the user ID of the Coordinator from the Papyrus Users screen and enter in the command below.

Suppose the Coordinator ID is 2 and the user running this command ID is 1.

```
RAILS_ENV=production bundle exec rake import:students COORDINATOR_ID=2 CREATOR_ID=1 EMAIL_REPORT_LOG_TO=me@me.ca FILE=/path/to/students.csv
```

## Deactivating students

```
RAILS_ENV=production bundle exec rake utils:deactivate_students
```
