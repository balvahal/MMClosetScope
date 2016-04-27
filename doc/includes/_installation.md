# Installation

This a guide to installing Super-Dimensional-Acquisition on a Windows machine.

<iframe width="100%" max-width="560px" src="https://www.youtube.com/embed/hYHKAqgF4O0" frameborder="0" allowfullscreen></iframe>

1. Install Micro-Manager
  + Use the latest version of Micro-Manager. Micro-Manager can be downloaded [here](https://micro-manager.org/wiki/Version_2.0).
2. Install Python
  + Use the latest version of [Python 3](www.python.org/downloads/).
3. Modify the Windows Path Variable
  + From the Windows Search Bar, enter "environment variables" and select the best match to "Edit the system environment variables". From the Systems Properties dialog box select "Environment Variables..." in the lower right. Edit the variable named "Path". Add 2 new lines that point to the directory with Python and the Python sub-directory Scripts; e.g. "C:\Python35" and "C:\Python35\Scripts".
4. Download SDA from Github
  + Download the [SDA](https://github.com/balvahal/supdimacq/archive/master.zip) zip file and extract the contents.
5. Modify the MATLAB Path
  + Within MATLAB in the Enviroment section of the Toolstrip there is a "Set Path" icon. Selecting this icon will open a window where the SDA files extracted from the prior step can be added to the MATLAB path. Select "Add with Subfolders..." and save before exiting.
6. Modify the MATLAB Javaclass Path
  + The MATLAB Javaclass Path is a separate path from the one modified in the prior step. From the command line run the scrip `core_setup_javaclasspath` and input the static path to the Micro-Manager installation as a string. Then navigate to the MATLAB prefdir from a Windows File Explorer and create (or modify) a file named "javaclasspath.txt". Copy the contents of "MMjavaclasspath.txt" into the other file. MATLAB must be restarted before it recognizes this modification.