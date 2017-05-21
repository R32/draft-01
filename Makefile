
HHC := "D:/Program Files/HTML Help Workshop/hhc.exe"

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
