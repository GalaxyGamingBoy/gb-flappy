name := flappy

src := src/utils/background.o  		  \
	   src/utils/interrupts.o  		  \
	   src/utils/sprites.o     		  \
	   src/utils/vblank.o	   		  \
	   src/utils/memory.o      		  \
	   src/utils/metasprites.o 		  \
	   src/states/game/game.o  		  \
	   src/states/title/title.o		  \
	   src/states/game/objs/player.o  \
	   src/states/game/objs/pipe.o

libs := libs/sprobj.o \
		libs/input.o  \
		libs/rand.o

deps := src/$(name).o $(libs) $(src)

title    := Flappy Bird
licensee := MM
version  := 1
debug    := 0

RGBASM     := rgbasm
RGBLINK    := rgblink
RGBFIX     := rgbfix
EMULICIOUS := Emulicious
PYTHON     := python3

run: $(name).gb
	Emulicious ./src/gen/$(name).gb

qr: $(name).gb
	7zz a ./src/gen/$(name).gb.zip ./src/gen/$(name).gb
	base64 -i ./src/gen/$(name).gb.zip | qrencode -o ./src/gen/$(name).png
	rm ./src/gen/$(name).gb.zip

clean:
	rm -r src/gen/
	rm $(deps)

gfx:
	$(PYTHON) gfx.py

%.o: %.asm
	$(RGBASM) -D DBG=$(debug) -o $@ $^

$(name).gb: $(deps)
	$(RGBLINK) -o src/gen/$(name).gb $(deps)

all: $(name).gb
	$(RGBFIX) -v -t "$(title)" -k "$(licensee)" -i $(name) -n $(version) -p 0xFF src/gen/$(name).gb
