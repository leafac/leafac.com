.PHONY: build buid/clean deploy documentation documentation/deploy documentation/clean clean

build:
	raco pollen render --recursive source
	raco pollen publish source target

build/clean:
	rm -rf target

deploy: build
	rsync -av --delete target/ leafac.com:leafac.com/websites/www.leafac.com/
	rsync -av target/software/index.html leafac.com:leafac.com/websites/software/index.html

documentation: compiled-documentation/index.html

compiled-documentation/index.html: documentation/www.leafac.com.scrbl
	raco scribble --dest compiled-documentation/ --dest-name index -- documentation/www.leafac.com.scrbl

documentation/deploy: documentation
	rsync -av --delete compiled-documentation/ leafac.com:leafac.com/websites/software/www.leafac.com/

documentation/clean:
	rm -rf compiled-documentation

clean: build/clean documentation/clean
