# Microscope
An object created with the `microscope` class is a wrapper for the instantiation of Micro-Manager within MATLAB. The methods of microscope have been created to handle common tasks, such as moving a motorized stage or snapping and image.

## Snapping an Image
Capturing an image and interacting with this data in MATLAB requires just a few steps. Try out this code:
```matlab
microscope = sda.microscope;
microscope.snapImage;
imagesc(microscope.I);
```
