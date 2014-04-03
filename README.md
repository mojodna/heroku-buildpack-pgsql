# heroku-buildpack-pgsql

I am a Heroku buildpack that installs updated PostgreSQL binaries, headers, and
libraries. (The binary bit is the important part, as cedar images do not
include `psql`.)

When used by myself, I will install PostgreSQL libraries, headers, and
binaries. *Note:* it does *not* currently include the Python bindings.

When used with
[heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi),
I enable subsequent buildpacks / steps to link to these libraries.  (You'll
need to use the `build-env` branch of [@mojodna's
fork](https://github.com/mojodna/heroku-buildpack-multi/tree/build-env) for the
build environment (`CPATH`, `LIBRARY_PATH`, etc.) to be set correctly.)

## Using

### Standalone

When creating a new Heroku app:

```bash
heroku apps:create -b https://github.com/mojodna/heroku-buildpack-pgsql.git

git push heroku master
```

When modifying an existing Heroku app:

```bash
heroku config:set BUILDPACK_URL=https://github.com/mojodna/heroku-buildpack-pgsql.git

git push heroku master
```

### Composed

When creating a new Heroku app:

```bash
heroku apps:create -b https://github.com/mojodna/heroku-buildpack-multi.git#build-env

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-pgsql.git
...
EOF

git push heroku master
```

When modifying an existing Heroku app:

```bash
heroku config:set BUILDPACK_URL=https://github.com/mojodna/heroku-buildpack-multi.git#build-env

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-pgsql.git
...
EOF

git push heroku master
```

## Building

PostgreSQL was built in an Ubuntu 10.04 chroot / VM with the following options.
(See [heroku/stack-images](https://github.com/heroku/stack-images) for package
listings and post-installation.)

```bash
mkdir -p /app/vendor
curl -LO http://ftp.postgresql.org/pub/source/v9.3.0/postgresql-9.3.0.tar.gz
tar xf postgresql-9.3.0.tar.gz
./configure --prefix=/app/vendor/pgsql --with-openssl
make -C src/bin install-strip && \
  make -C src/include install-strip && \
  make -C src/interfaces install-strip
cd /app/vendor/pgsql
tar zcf /tmp/pgsql-9.3.0-1.tar.gz .
```
