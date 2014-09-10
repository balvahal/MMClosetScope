%% Setup
% Before SuperMDA will work, the uManager software must be properly
% configured for the microscope. This must include the following:
%
% # Define the pixel size within uManager.
%% How to Use the SuperMDA
%
% 1. Open micro-manager through MATLAB. MATLAB will create an object that
% can be used to interface with the micro-manager API.
%
% |>> mm = Core_MicroManagerHandle;|
%
% 2. Create an _itinerary_ object. This object contains a structure that
% details the what, when, and where of the microscope. The _mm_ object just
% created must be used to initialize the itinerary.
%
% |>> smdaI = SuperMDAItinerary(mm);|
%
% 3. The new object _smdaI_ can be edited from the command line or
% configured using a script. Additionally, a gui was created to help
% facilitate common uses of the SuperMDA. This gui mimics what can be done
% with other common microscope softwares such as Metamorph and Nikon
% Elements. Programming the SuperMDA is necessary to tap into funtionality
% beyond what other softwares provide. The gui is contained within a
% wrapper object called the _travel agent_. It helps configure the
% itinerary. The intinerary must already be created and it is used to
% initialize the travel agent.
%
% |>> smdaTA = SuperMDATravelAgent(smdaI);|
%
% 4. Finally, once the itinerary is configured another object is used to
% control the microscope called the _pilot_. The pilot object consists of a
% timer that iterates through the itinerary struct and contains the code
% that communicates with the microscope through micro-manager. The
% itinerary is used to initialize the pilot.
%
% |>> smdaP = SuperMDAPilot(smdaI);|
%
% 5. To start the acquisition use the |start_acquisition| method in the
% pilot.
%
% |>> smdaP.start_acquisition;|
%
%% Sensor Calibration
%
% Often the axes of the camera sensor are misaligned with the axes of the
% stage movement. The angle between these axes can be calculated through a
% little image analysis and used to properly create grids.
%
% 1. Focus on something of high contrast: a group of cells in
% phase-contrast works very well. Place the high contast item in the center
% of the field of view. Then use the |calibrateSensorAlignment| method.
%
% |>> mm.calibrateSensorAlignment;|
%
% A configuration file located on the computer connected to the microscope
% will save this angle, so calibration will not be necessary every time the
% SuperMDA is run.
%% Changing settings for all positions
%
% The travel agent has methods to perform common tasks that manipulate the
% itinerary. For example, if a property of all the settings in a particular
% group should be changed to the same value use the |changeAllSettings|
% method. This method requires as input the number of the group and the
% name of the property and the property value. In summary, a property for
% all settings at all positions in a given group will be changed with this
% method.
%
% |>> smdaTA.changeAllSettings(1,'settings_function_name','Jose2x2.m');|
