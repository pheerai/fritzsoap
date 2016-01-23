DD = dmd
DDFLAGS = -w -unittest -of"./bin/fritzsoap" -od".bin/obj/"
MAINFLAGS = $(DDFLAGS)

all:
	$(DD) $(MAINFLAGS) src/soapsocket.d src/fritzsoap.d 

clean:
	rm bin/fritzsoap
