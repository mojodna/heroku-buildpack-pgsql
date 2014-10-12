default: cedar cedar-14

cedar: dist/cedar/pgsql-9.3.5-1.tar.gz

cedar-14: dist/cedar-14/pgsql-9.3.5-1.tar.gz

dist/cedar-14/pgsql-9.3.5-1.tar.gz: cedar-14-stack
	docker cp $<:/tmp/pgsql-$<.tar.gz .
	mkdir -p $$(dirname $@)
	mv pgsql-$<.tar.gz $@

dist/cedar/pgsql-9.3.5-1.tar.gz: cedar-stack
	docker cp $<:/tmp/pgsql-$<.tar.gz .
	mkdir -p $$(dirname $@)
	mv pgsql-$<.tar.gz $@

clean:
	rm -f cedar-stack/cedar.sh cedar-stack/postgresql.tar.gz
	rm -f cedar-14-stack/cedar-14.sh cedar-14-stack/postgresql.tar.gz
	rm -rf src/ cedar/ cedar-14/
	-docker rm cedar-stack
	-docker rm cedar-14-stack

src/postgresql.tar.gz:
	mkdir -p $$(dirname $@)
	curl -sL http://ftp.postgresql.org/pub/source/v9.3.5/postgresql-9.3.5.tar.gz -o $@

.PHONY: cedar-14-stack

cedar-14-stack: cedar-14-stack/cedar-14.sh cedar-14-stack/postgresql.tar.gz
	docker build --rm -t mojodna/$@ $@
	-docker rm $@
	docker run --name $@ mojodna/$@ /bin/echo $@

cedar-14-stack/cedar-14.sh:
	curl -sL https://raw.githubusercontent.com/heroku/stack-images/master/bin/cedar-14.sh -o $@

cedar-14-stack/postgresql.tar.gz: src/postgresql.tar.gz
	ln -f $< $@

.PHONY: cedar-stack

cedar-stack: cedar-stack/cedar.sh cedar-stack/postgresql.tar.gz
	docker build --rm -t mojodna/$@ $@
	-docker rm $@
	docker run --name $@ mojodna/$@ /bin/echo $@

cedar-stack/cedar.sh:
	curl -sL https://raw.githubusercontent.com/heroku/stack-images/master/bin/cedar.sh -o $@

cedar-stack/postgresql.tar.gz: src/postgresql.tar.gz
	ln -f $< $@
