#!/bin/bash
bundle install
JEKYLL_ENV=production bundle exec jekyll build 
# && scp -r _site root@cedrictemple.net:/var/www/blog.cedrictemple.net/
