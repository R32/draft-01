# PAS should be provided by `make PAS=XXXXXX` when **RELEASE**
PAS := DEBUG
# VER := git@$(shell git rev-parse --short HEAD)
# HHC always return ERROR in cygwin even have successfully compiled
HHC := "D:/Program Files/HTML Help Workshop/hhc.exe"

# closure.bat: java -jar "%~dp0closure-compiler-v20170423.jar" %*
CCJS:= closure

ifndef PAS
$(error PAS must be provided. e.g: make all PAS=XXXXXX)
endif


all: css

css: dist/style.css

clean:
	rm -rf dist/style.css



dist/style.css: hss/style.hss hss/primer.hss hss/comp.hss
	hss $< -output dist/

hss/primer.hss: $(foreach dir,hss/primer, $(wildcard $(dir)/*.hss))

.PHONY: clean
