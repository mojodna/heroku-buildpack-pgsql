# heroku-buildpack-pgsql

I am a Heroku buildpack that installs updated PostgreSQL binaries, headers, and
libraries. (The binary bit is the important part, as cedar images do not
include `psql`.)

When used by myself, I will install PostgreSQL libraries, headers, and
binaries. *Note:* it does *not* currently include the Python bindings.

When used with
[heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi),
I enable subsequent buildpacks / steps to link to these libraries.

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
heroku apps:create -b https://github.com/ddollar/heroku-buildpack-multi.git

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-pgsql.git
...
EOF

git push heroku master
```

When modifying an existing Heroku app:

```bash
heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-pgsql.git
...
EOF

git push heroku master
```

## Building

This uses Docker to build against Heroku
[stack-image](https://github.com/heroku/stack-images)-like images.

```bash
make
```

Artifacts will be dropped in `dist/`.  See `Dockerfile`s for build options.
