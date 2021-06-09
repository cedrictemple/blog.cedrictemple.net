#!/bin/bash

pkill jekyll
sleep 2
JEKYLL_ENV=production jekyll build && scp -r _site root@cedrictemple.net:/var/www/blog.cedrictemple.net/
