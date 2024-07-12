#!/bin/bash

curl -k -n -s -X DELETE https://api.heroku.com/apps/$HEROKU_APP_NAME/dynos \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.heroku+json; version=3" \
  -H "Authorization: Bearer $HEROKU_API_KEY"

sleep 10
