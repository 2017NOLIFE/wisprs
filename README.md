# Secured Chatting API

API for secure chatting between users

## Routes

### Application Routes

- GET `/`: main route

### Message Routes

- GET `api/v1/messages`: returns a json of all the messages
- GET `api/v1/messages/[ID].json`: returns a json of all information about a message with given ID
- GET `api/v1/messages/[ID]/document`: returns a text/plain document with a message document for given ID
- POST `api/v1/messages/`: creates a new message

## Install

Install this API by cloning the *relevant branch* and installing required gems:

    $ bundle install


## Testing

Test this API by running:

    $ RACK_ENV=test rake db:migrate
    $ bundle exec rake spec

## Develop

Run this API during development:

    $ rake db:migrate
    $ bundle exec rackup

or use autoloading during development:

    $ bundle exec rerun rackup
