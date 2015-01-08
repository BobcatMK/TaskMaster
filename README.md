Copyright © 2015 Matthew Kilan

================ ABOUT APPLICATION ================

This application was created for personal and if opportunity arises - commercial use.

This is todo application written with following technologies:
1. HTML5
2. CSS3
3. Ruby 2.1.5
4. Ruby on Rails 4.1.8
5. Javascript
6. AJAX
7. PostgreSQL database

TaskMaster was created with SPA in mind, this is why when using this application you get experience of normal desktop application.

What is it used for?
Well it used in order to help you manage your life.
TaskMaster allows you to create task for each day from 1 Jan 2014 until 30 Dec 2030.
You can browse tasks based on:
1. Day view
2. Week view
3. Month view
4. Tasks view (completed,uncompleted,all)

You can also create ToDo lists where you can place any tasks you want, and easily repeat them on daily basis.

If you feel like taking notes, then also notes panel will be the place for you to go. There you can create folders, files, manage your folders & files. You can even send your note over built in email sender to anyone you want to.

<b>Feel like checking out this awesome application?</b>

Visit my website on heroku:

<a href="https://taskmaster-todo-app.herokuapp.com/">https://taskmaster-todo-app.herokuapp.com/</a>

<b>Tell me what you think about it! Your feedback is EXTREMELY important</b>

1.My email address: <a href="mailto:matthew.kilan@gmail.com">matthew.kilan@gmail.com</a>
2.You can also send me email via TaskMaster, once registered, press "Menu" button on right top and press "Contact", then scroll down and follow simple instructions to send me a message.

========================= INSTALLING APPLICATION =========================

YOU CAN USE THIS APP ONLY FOR LEARNING PURPOSES, YOU CAN'T COPY OR REUSE IT'S CODE WITHOUT MY CONSENT.

Copyright © 2015 Matthew Kilan

Application is using:
* ruby 2.1.5
* ruby on rails 4.1.8

1. Once you copied this app to your destination folder remember about creating/copping database.yml file to config/ . This application is running PostgreSQL, so it's important to set up everything correctly.

For example on localhost I'm running with the following configurations:

default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: 5

development:
  <<: *default
  database: TaskMaster_Rails_development
  host: localhost
  username: --YOUR-PSQL-USERNAME--
  password: --YOUR-PSQL-PASSWORD--

2. If you want to have fully functional mailers in development environment remember about installing FIGARO GEM and placing there following info:

DOMAIN_NAME: "write-here-anything-you-like"
GMAIL_USERNAME: "your-gmail-username"
GMAIL_PASSWORD: "your-gmail-password"

3. run in terminal "rake db:create"

4. "rake db:migrate"

5. "rake db:seed"

6. If you want to run this app with unicorn server remember about installing foreman gem:
"sudo gem install foreman"
And don't place it in Gemfile.

Run unicorn with "foreman start" in terminal.








