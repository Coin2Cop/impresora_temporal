from PIL import Image
import sys

img = Image.open('assets/images/192xeler.png')
print(f"Size: {img.size}")
print(f"Mode: {img.mode}")

# Check some pixels
pixels = img.load()
# Corners (should be transparent)
print(f"Top-left (0,0): {pixels[0,0]}")
# Middle of background (left side)
print(f"Mid-left (20, 100): {pixels[20,100]}")
# Middle of background (right side)
print(f"Mid-right (170, 100): {pixels[170,100]}")
# Fox head (center)
print(f"Center (96, 96): {pixels[96,96]}")
