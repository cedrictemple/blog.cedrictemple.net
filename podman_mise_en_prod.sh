#!/bin/bash
podman container list | grep -v CONTAINER | awk '{print $1;}' | while read a; do podman stop $a; done
podman run --rm -it --network host -v "/home/cedric/GIT/blog.cedrictemple.net:/srv/jekyll" -e JEKYLL_ROOTLESS=1 -e BUNDLE_APP_CONFIG='.bundle' jekyll/jekyll:stable bash ./jekyll_build_for_prod.sh
#scp -r ~/GIT/blog.cedrictemple.net/_site root@cedrictemple.net:/var/www/blog.cedrictemple.net/
