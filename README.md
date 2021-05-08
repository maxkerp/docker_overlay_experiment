
# Experiment: Overlay files of a container with host files

## Problem:

I'm thinking about creating a docker image of valve's half-life dedicated server.

Since playing those games without one or the other mod isn't that much fun I
need to support adding and configuring mods and custom maps.

Building a new container every time I add a map or a mod isn't that great.

If it where for just config files I should use volumes for this, but since
it's not I tried to figure out how to get the union of the default files and the
"mod_folder" files on top of that. The `mod_folder` resides on the `host`.

This repo is the proof-of-concept that it could theoretically be done.
(Actually running the dedicated server like this will probably be harder for
reasons I don't know' right now.)

## Solution

An overlay `mount` at runtime of both the plain `mod_folder` and the one of the
`host` with all the mods and custom maps installed is apparently the way to go.

This container is the proof-of-concept.

Build with like this:
```sh
docker build --tag proof-overlay:dev .
```

Run like this:
(For the `mount` to work the container needs specific privileges)

```sh
docker run --rm  \
  -v ~/repos/docker_overlay_experiment/mod_folder:/parent/mod \
  --cap-add=SYS_ADMIN \
  --security-opt=apparmor:unconfined \
  proof-overlay:dev
```

You should be seeing this:
```
File contents of app_dir

Layer 0: This content is of the lowest layer and should NOT be overlayed.
Layer 0: This content is of the lowest layer and SHOULD be overlayed.

File contents of mod_dir

cat: /parent/mod/kept_file.txt: No such file or directory
Layer 1: This content is of the upper layer and SHOULD overlay other content.

File contents of merged_dir

Layer 0: This content is of the lowest layer and should NOT be overlayed.
Layer 1: This content is of the upper layer and SHOULD overlay other content.

/parent
|-- app
|   |-- kept_file.txt
|   `-- overlayed_file.txt
|-- merged
|   |-- kept_file.txt
|   `-- overlayed_file.txt
`-- mod
    `-- overlayed_file.txt

    3 directories, 5 files
```

## Links that I found useful:
* https://unix.stackexchange.com/questions/598219/how-to-use-overlay-mount-to-combine-multiple-directories-with-different-sub-dire
* https://wiki.archlinux.org/title/Overlay_filesystem
* https://superuser.com/questions/1464516/cannot-complete-overlay-fs-mount-within-docker-container
* https://stackoverflow.com/questions/32510778/error-using-mount-command-within-dockerfile

