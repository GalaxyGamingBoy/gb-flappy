import os

colors = "#0F380F,#306230,#8BAC0f,#000000"

print("Generating GameBoy GFX Files... ")
os.makedirs("src/gen/sprs", exist_ok=True)
for spr in os.listdir("src/res/sprs"):
    if not spr.endswith(".png"):
        continue
    print(spr)
    os.system(f'rgbgfx --columns -o src/gen/sprs/{spr.removesuffix(".png")}.2bpp src/res/sprs/{spr}')

os.makedirs("src/gen/bgs", exist_ok=True)
print("WARNING! BACKGROUND TILE GENERATION IS NOT YET IMPLEMENTED - PLEASE COPY AND PASTE THE COMMANDs BELOW TO GENERATE THEM")
for bg in os.listdir("src/res/bgs"):
    if not bg.endswith(".png"):
        continue
    print(bg)

    print(f'rgbgfx --tilemap src/gen/bgs/{bg.removesuffix(".png")}.tilemap --unique-tiles -o src/gen/bgs/{bg.removesuffix(".png")}.2bpp src/res/bgs/{bg}')
    
print("OK!")
