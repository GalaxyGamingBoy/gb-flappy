import os

print("Generating GameBoy GFX Files... ", end="")
os.makedirs("src/gen/sprs", exist_ok=True)
for spr in os.listdir("src/res/sprs"):
    os.system(f'rgbgfx -c "#FFFFFF,#CFCFCF,#686868,#000000;" --columns -o src/gen/sprs/{spr.removesuffix(".png")}.2bpp src/res/sprs/{spr}')

os.makedirs("src/gen/bgs", exist_ok=True)
for bg in os.listdir("src/res/bgs"):
    os.system(f'rgbgfx -c "#FFFFFF,#CBCBCB,#414141,#000000;" -o src/gen/bgs/{bg.removesuffix(".png")}.2bpp src/res/bgs/{bg}')
    os.system(f'rgbgfx -c "#FFFFFF,#CBCBCB,#414141,#000000;" --tilemap src/gen/bgs/{bg.removesuffix(".png")}.tilemap --unique-tiles -o src/gen/bgs/{bg.removesuffix(".png")}.2bpp src/res/bgs/{bg}')
print("OK!")