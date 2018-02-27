.PHONY: server install deploy documentation documentation/deploy

server:
	raco pollen start source/

install:
	pip install pygments
	raco pkg install --name www-leafac-com $(CURDIR)

deploy:
	raco pollen reset && \
	raco pollen render --recursive $(CURDIR)/source && \
	temporary_directory=$$(mktemp -d) && \
	raco pollen publish $(CURDIR)/source $$temporary_directory && \
	rsync -av --delete $$temporary_directory/ leafac.com:leafac.com/websites/www.leafac.com/ && \
	rsync -av $$temporary_directory/software/index.html leafac.com:leafac.com/websites/software/index.html

################################################################################

project = www.leafac.com

documentation: documentation/index.html

documentation/index.html: documentation/$(project).scrbl
	cd documentation && raco scribble --dest-name index -- $(project).scrbl

documentation/deploy: documentation
	rsync -av --delete documentation/ leafac.com:leafac.com/websites/software/$(project)/
