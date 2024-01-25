#!/bin/bash
podman run --rm -it --network host -v "/home/cedric/GIT/blog.cedrictemple.net:/srv/jekyll" -e JEKYLL_ROOTLESS=1 -e BUNDLE_APP_CONFIG='.bundle' jekyll/jekyll:stable bash ./jekyll_live.sh

