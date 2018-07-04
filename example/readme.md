# Example setup for single-docker node Caller's Bane server / mysql containers

This `docker-compose.yml` requires that a mysql data volume is mounted to /var/lib/mysql and that Caller's Bane configuration volume is mounted to /callersbane/CallersBane-Server/cfg. The docker compose file uses the following local folders respectively:

- `/c/mnt/docker/callersbane/mysql` - mysql database files
- `/c/mnt/docker/callersbane/conf` - `hibernate.cfg.xml` (see installation_instructions.txt inside Caller's Bane download archive)

These folders are assumed to contain the correct data already. To initialize the data you can use the [init script](../init).

Run with:

```bash
docker-compose up -d
```

Note: On Windows you might have better luck running `start.ps1` instead of standard `docker-compose up -d`. See [issue](https://github.com/docker/for-win/issues/1829). The version it was tested on was `18.03.1-ce-win65 (17513)`, your milage may vary.

Note: mysql port is not forwarded for security reasons. If you need to connect to mysql to edit the database bring the containers down with `docker-compose down`, create a temporary mysql with `docker run --rm --name tmp-mysql -v /c/mnt/docker/callersbane/mysql:/var/lib/mysql -d -p 3306:3306 mysql:5.7.22`, connect to port 3306 and do the changes, remove the temp container with `docker stop tmp-mysql` and do `docker-compose up -d` (or run `start.ps1` if on windows) again.
