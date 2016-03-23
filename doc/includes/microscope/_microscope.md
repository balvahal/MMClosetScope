# Microscope
An object created with the `microscope_class` is a wrapper for the instantiation of Micro-Manager within MATLAB. The methods of microscope have been created to handle common tasks, such as moving a motorized stage or snapping and image.

## Snapping an Image

> Try out this code to snap an image:

```matlab
microscope = sda.microscope; %If a microscope object already exists, skip this.
microscope.snapImage;
imagesc(microscope.I);
```

Capturing an image and interacting with this data in MATLAB requires just a few steps. 


