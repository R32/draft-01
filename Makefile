
HHC := "D:/Program Files/HTML Help Workshop/hhc.exe"

## closure.bat === java -jar "%~dp0closure-compiler-v20170423.jar" %*
CCJS:= closure



# make all PAS=XXXXXXXX
ifdef PAS
all:
	@echo run build...
else
all:
	@echo did not do anything.
endif

clean:
	@echo clean...

.PHONY: clean
