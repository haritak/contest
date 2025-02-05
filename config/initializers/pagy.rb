# require 'pagy/extras/countless'

Pagy::DEFAULT[:limit] = 200 # items per page
Pagy::DEFAULT[:size]  = 40  # nav bar links
# Better user experience handled automatically
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page
