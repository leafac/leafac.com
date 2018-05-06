.PHONY: default install server build clean deploy documentation documentation/deploy

source = $(CURDIR)/source/
target = $(CURDIR)/docs/

default: server

install:
	pip install pygments
	raco pkg install --name www-leafac-com $(CURDIR)

server:
	cd $(source) && raco pollen start

build:
	cd $(source) && raco pollen render auxiliary.ptree index.ptree
	cd $(source) && raco pollen publish . $(target)

clean:
	git clean -fdX

deploy: clean build
	git add -A
	git commit -m "Deploy"
	git push origin

################################################################################

project = www.leafac.com

documentation: documentation/index.html

documentation/index.html: documentation/$(project).scrbl
	cd documentation && raco scribble --dest-name index -- $(project).scrbl

documentation/deploy: documentation
	rsync -av --delete documentation/ leafac.com:leafac.com/websites/software/$(project)/
