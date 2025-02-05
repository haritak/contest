#!/bin/bash

# bin/rails db:encryption:init (αν χρησιμοποιούμε encryption)
# bin/rails credentials:edit --environment production


export RAILS_ENV=production
#rails assets:clobber
#RAILS_ENV=production bin/rails db:migrate
#RAILS_ENV=production bin/rails assets:precompile
rails s -e production

