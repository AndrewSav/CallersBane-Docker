# Caller's Bane server container

This is the Dockerfile for building the Caller's Bain server docker image. It is _minimal_, which means that it does not include mysql that is required for it to function, and expect mysql to be set up separately. You will have to map `/callersbane/CallersBane-Server/cfg` path from this image when creating a container to an external volume and put appropriate `hibernate.cfg.xml` into this volume. Please read `installation_instructions.txt` in the Caller's Bane download archive at <https://callersbane.com/> for further details on the server configuaion.

Because the image is minimal, it allows its reuse in many different setups: it can be hosted in a cluster or on a stand-alone docker server, it can use containirized mysql or it can use already existing one, the posibilites are unlimited ;)

However this repository also proivides a sample setup for a single docker server, with mysql hosted in a container on that server. [Read more](../init) about how it works.

In order to build this image run:

```bash
docker build --no-cache -t andrewsav/callersbane .
```

You can push it to a regesry:

```bash
docker login
docker push andrewsav/callersbane
```

And you can tag it with a tag:

```bash
docker tag andrewsav/callersbane andrewsav/callersbane:2018-07-04
docker push andrewsav/callersbane:2018-07-04
```
