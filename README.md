# cell_brightness
 EJR, ejr36 AT cam.ac.uk, 2016, CC-BY

 Approximately follows a cell-brightness estimating macro
 for ImageJ written by
 CHMM / GS, for sample image data from Gen Simpson
 
 Instructions:
 1. Run this script in Matlab
 2. Use the "open file" GUI to select one file of raw image data
 3. This script then attempts to process each image file in the same
 folder

 Notes:
 1. The background estimation parameter can be edited in section 0
 2. Sample image data seems to 8-bit values stored in a 32-bit tif
    (It seems possible my recommendations on file types have gone astray:
     because the 8-bit values may have been rescaled! But maybe not - max
     values of 203 (not 255) are identifiable.)
    ---> No! Some values go up to 600, and import as uint16

 Method:
 1. Based on the assumption that cells fill less than half of the frame,
 and that the background is a dark d.c. level with some noise, 
 the background d.c. level is estimated as the 25th percentile of the
 pixel values - this should have a mid-value from the background noise.
 2. A threshold is set at 
 (background) + 25% of (maximum pixel value - background) 
 3. Pixel values above threshold are considered to represent cells
 (If the cells are truly dark, it just grabs some noise pixels, which is 
 fine because these will have values similar to the actual cells in 
 this case. 
 4. Properties of the cells are listed as:
 listNames (file names, as a cell array)
 listBrightness (mean cell pixel value, without any background subtraction)
 listAreas (total cell area in pixels)
