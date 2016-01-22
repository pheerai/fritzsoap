DD = dmd
RELEASEFLAGS = -release -O
DEBUGFLAGS = -g -unittest -w
DEVFLAGS = -unittest -w
DDFLAGS = -od"./bin/obj/" -of"./bin/"

release :
	$(DD) $(RELEASEFLAGS)  src/fritzsoap.d

debug:
	$(DD) $(DEBUGFLAGS) -of"bin/fritzsoap" src/fritzsoap.d

dev:
	$(DD) $(DDFLAGS) -of"bin/fritzsoap" src/fritzsoap.d
