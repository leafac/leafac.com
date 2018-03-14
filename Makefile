.PHONY: default install server build clean deploy documentation documentation/deploy

source = $(CURDIR)/source/
target = $(CURDIR)/build/

default: server

install:
	pip install pygments
	raco pkg install --name www-leafac-com $(CURDIR)

server:
	raco pollen start $(source)

build:
	cd $(source) && raco pollen render index.ptree auxiliary.ptree
	raco pollen publish $(source) $(target)

clean:
	git clean -fdX

deploy: clean build
	rsync -av --delete $(target) leafac.com:leafac.com/websites/www.leafac.com/
	rsync -av $(target)software/index.html leafac.com:leafac.com/websites/software/index.html

################################################################################

project = www.leafac.com

documentation: documentation/index.html

documentation/index.html: documentation/$(project).scrbl
	cd documentation && raco scribble --dest-name index -- $(project).scrbl

documentation/deploy: documentation
	rsync -av --delete documentation/ leafac.com:leafac.com/websites/software/$(project)/
