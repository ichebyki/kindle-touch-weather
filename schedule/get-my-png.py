#!/usr/bin/env python
# PyWebShot - create webpage thumbnails. Originally based on 
# http://burtonini.com/computing/screenshot-tng.py
# Ben Dowling - http://www.coderholic.com

from html2image import Html2Image
from datetime import date

hti = Html2Image()
hti.browser.flags = ['--virtual-time-budget=100000', '--hide-scrollbars']
hti.screenshot(
	url='http://192.168.88.101',
	size=(600, 800),
	save_as='1.png'
)

# import the Python Image 
# processing Library
from PIL import Image, ImageDraw, ImageFont
  
# Giving The Original image Directory 
# Specified
Original_Image = Image.open("./1.png")
Original_Image = Original_Image.convert('L') # change to grayscale image

#import ufp.image
#ufp.image.changeColorDepth(Original_Image, 256) # change to 8bpp 
                                                 # this function change original PIL.Image object
  
# Rotate Image By 180 Degree
rotated_image1 = Original_Image.rotate(180)
rotated_image18 = rotated_image1.convert("L", palette=Image.ADAPTIVE, colors=256)
  
# This is Alternative Syntax To Rotate 
# The Image
rotated_image2 = Original_Image.transpose(Image.ROTATE_90)
rotated_image28 = rotated_image2.convert("L", palette=Image.ADAPTIVE, colors=256)
  
# This Will Rotate Image By 60 Degree
rotated_image3 = rotated_image2.rotate(180)
rotated_image38 = rotated_image3.convert("L", palette=Image.ADAPTIVE, colors=256)
  
rotated_image18.save("r180.png","PNG")
rotated_image28.save("r90.png","PNG")
rotated_image38.save("r-90.png","PNG")



font = 'arial'
fontsize = 20
font = ImageFont.truetype("c:/Windows/Fonts/" + font + ".ttf", fontsize, encoding="unic")
text2draw = str(date.today())

draw_txt = ImageDraw.Draw(rotated_image38)

bbox = draw_txt.textbbox((0, 0), text=text2draw, font=font)
# Add Text to an image
draw_txt.text((600 - bbox[2] - 10, 1), text2draw, font=font, fill="#FFF")
 
# Display edited image
#rotated_image38.show()
 
# Save the edited image
rotated_image38.save("r-90-x.png","PNG")