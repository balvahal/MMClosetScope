%% SuperMDA
% The first goal of SuperMDA is to unleash the power of MATLAB(R) on
% microscopy. This has been accomplished by creating a MATLAB(R) library
% built upon the micro-manager.org API. SuperMDA differs from the
% traditional multi-dimensional-acquisition (MDA), because now it is
% possible to idependently modify each aspect of the _what?_, _where?_, and
% _when?_ pertaining to image acquisition, including on-the-fly during
% operation, openning the possibility of incorporating feedback into the
% acquisition.
%
% Another goal is to have SuperMDA evolve an app-store like functionality.
% The flexibility of using MATLAB(R) means microscope behavior can be
% tailored to each experiment. Traditionally, MDA has been a
% one-size-fits-all tool, but microscopy experiments are becoming
% increasing complicated: light-controlled fluorophores, screening large
% libraries, lengthy time-lapse movies. SuperMDA can serve as a foundation
% for an application made to serve each purpose; of course, the SuperMDA
% can serve as a traditional MDA, too.
%
% SuperMDA has an instruction hierarchy. The lowest level is _settings_
% where most of the microscope details are defined. For example, filter
% sets, exposures times, and z-stack information is stored here. The next
% level is the _position_. The _position_ contains the (x,y,z) information
% of where the stage should be placed above the objective. The top level is
% the _group_, which is meant to organize sets of positions. Note, that
% _group of groups_ is being considered as another level of the hierarchy.
% The relationship between these levels of instructional information is
% specified and stored within a group-position-settings (GPS) matrix. More
% detail into the SuperMDA instruction hierarchy can be found
% <SuperMDAItineraryTimeFixed_object here>.
%
% SuperMDA is meant to integrate more seemlessly into the data analysis
% pipeline by making the images acquired immediately available to the
% MATLAB(R) environment. The SuperMDA solution is simple: create a helpful
% database, a tab-delimited table, that is easily parsed. A separate
% project uses this database as a starting point for image analysis.
% Additionally, this database can be transformed into a CSV file for use in
% the cellprofiler.org image analysis software.
%% Function List
%
% # *<SuperMDA_database2CellProfilerCSV.html
% SuperMDA_database2CellProfilerCSV>* : Transform the default database into
% a CSV file recognized by the cellprofiler.org open source software.
% cellprofiler.org is especially great for fixed cells.
% # *<SuperMDA_grid_maker.html SuperMDA_grid_maker>* : Creates a list of
% (x,y) coordinates that can be used to acquire images over a rectangular
% area.
% # *<SuperMDAItineraryTimeFixed_group_function_after.html
% SuperMDAItineraryTimeFixed_group_function_after>* : Default instructions
% set to execute _after_ looping through a group of positions.
% # *<SuperMDAItineraryTimeFixed_group_function_before.html
% SuperMDAItineraryTimeFixed_group_function_before>* : Default instructions
% set to execute _before_ looping through a group of positions.
% # *<SuperMDAItinearyTimeFixed_method_addPosition2Group.html
% SuperMDAItineraryTimeFixed_method_addPosition2Group>* : A method that
% maintains the fidelity of the itinerary while adding a new position to a
% given group.
% # *<SuperMDAItineraryTimeFixed_method_addSettings2AllPosition.html
% SuperMDAItineraryTimeFixed_method_addSettings2AllPosition>* : It is
% common to share settings between a group of positions. This function will
% add a new settings to each position in a given group.
% # *<SuperMDAItineraryTimeFixed_method_addSettings2Position.html
% SuperMDAItineraryTimeFixed_method_addSettings2Position>* : A settings is
% created and added to a given position.
% # *<SuperMDAItineraryTimeFixed_method_export.html
% SuperMDAItineraryTimeFixed_method_export>* : The contents of an instance
% of the |SuperMDAItineraryTimeFixed_object| can be saved in a text file
% using this function.
% # *<SuperMDAItineraryTimeFixed_method_import.html
% SuperMDAItineraryTimeFixed_method_import>* : A previously saved
% |SuperMDAItineraryTimeFixed_object| can replace the contents of a
% |SuperMDAItineraryTimeFixed_object| currently in the workspace.
% # *<SuperMDAItineraryTimeFixed_method_newGroup.html
% SuperMDAItineraryTimeFixed_method_newGroup>* : The fidelity of the
% itinerary is maintained and a new group is added.
% # *<SuperMDAItineraryTimeFixed_method_newPosition.html
% SuperMDAItineraryTimeFixed_method_newPosition>* : The fidelity of the
% itinerary is maintained and a new position is added.
% # *<SuperMDAItineraryTimeFixed_method_newPositionNewSettings.html
% SuperMDAItineraryTimeFixed_method_newPositionNewSettings>* : A new
% position is added along with a new settings.
% # *<SuperMDAItineraryTimeFixed_method_newSettings.html
% SuperMDAItineraryTimeFixed_method_newSettings>* : The fidelity of the
% itinerary is maintained and a new settings is added.
% # *<SuperMDAItineraryTimeFixed_object.html
% SuperMDAItineraryTimeFixed_object>* : An object that houses the
% itinerary, which is a set of instructions that specify the _what?_,
% _where?_, and _when?_ pertaining to image acquisition.
% # *<SuperMDAItineraryTimeFixed_position_function_after.html
% SuperMDAItineraryTimeFixed_position_function_after>* : Default
% instructions set to execute _after_ visiting a position.
% # *<SuperMDAItineraryTimeFixed_position_function_before.html
% SuperMDAItineraryTimeFixed_position_function_before>* : Default
% instructions set to execute _before_ visiting a position.
% # *<SuperMDAItineraryTimeFixed_settings_function.html
% SuperMDAItineraryTimeFixed_settings_function>* : Default instructions set
% to execute at a position. This function configures the binning, gain,
% channel, and z-stack. An image(s) is acquired and the database is
% updated.
% # *<SuperMDAItineraryTimeFixed_settings_function_2x2grid.html
% SuperMDAItineraryTimeFixed_settings_function_2x2grid>* : Instructions
% that configure everything in the default, except z-stack. A 2x2 grid
% centered at the selected position is acquired.
% # *<SuperMDAItineraryTimeFixed_settings_function_minimal.html
% SuperMDAItineraryTimeFixed_settings_function_minimal>* : Instructions
% that configure everything in the default, except the z-stack. The z-stack
% requires loops, so removing the z-stack makes a very compact file.
% # *<SuperMDAItineraryTimeTunable_object.html
% SuperMDAItineraryTimeTunable_object>* : In contrast to the _TimeFixed_
% itinerary, this object has several parameters defined for every
% timepoint. These parameters are timepoints, exposure, and (x,y,z).
% # *<SuperMDAPilot_function_timerRuntimeFunContinuousCapture.html
% SuperMDAPilot_function_timerRuntimeFunContinuousCapture>* : Continuous
% capture means the itinerary is looped through repeatedly.
% # *<SuperMDAPilot_function_timerRuntimeStopFun.html
% SuperMDAPilot_function_timerRuntimeStopFun>* : A special stop function is
% created for the MATLAB(R) timer object that trigger at the times
% specified in the itinerary.
% # *<SuperMDAPilot_function_timerRuntimeStopFunContinuousCapture.html
% SuperMDAPilot_function_timerRuntimeStopFunContinuousCapture>* : A special
% stop function is created for the MATLAB(R) timer object that triggers
% continuously, effectively creating a |for| loop. A |for| loop wasn't
% used, so that the _Pilot_ object could be reused.
% # *<SuperMDAPilot_gui_lastImage.html SuperMDAPilot_gui_lastImage>* : A
% figure that displays the last image collected through the SuperMDA.
% # *<SuperMDAPilot_gui_puase_stop_resume.html
% SuperMDAPilot_gui_pause_stop_resume>* : A figure that displays the time
% between acquisitions and several buttons to pause, stop, and resume the
% acquisition.
% # *<SuperMDAPilot_method_oneLoop.html SuperMDAPilot_method_oneLoop>* : 
% # *<SuperMDAPilot_method_pause_acquisition.html
% SuperMDAPilot_method_pause_acquistion>* : 
% # *<SuperMDAPilot_method_resume_acquisition.html
% SuperMDAPilot_method_resume_acquisition>* : 
% # *<SuperMDAPilot_method_startAcquisition.html
% SuperMDAPilot_method_startAcquisition>* : 
% # *<SuperMDAPilot_method_startAcquisitionContinuousCapture.html
% SuperMDAPilot_method_startAcquisitionContinuousCapture>* :
% # *<SuperMDAPilot_method_stop_acquisition.html
% SuperMDAPilot_method_stop_acquisition>* : 
% # *<SuperMDAPilot_method_timerRuntimeFun.html
% SuperMDAPilot_method_timerRuntimeFun>* :
% # *<SuperMDAPilot_method_update_database.html
% SuperMDAPilot_method_update_database>* : 
% # *<SuperMDAPilot_method_updateLastImage.html
% SuperMDAPilot_method_updateLastImage>* : 
% # *<SuperMDAPilot_method_wait.html SuperMDAPilot_method_wait>* : 
% # *<SuperMDAPilot_object.html SuperMDAPilot_object>* : 
% # *<SuperMDATravelAgent_gui_main.html SuperMDATravelAgent_gui_main>* : 
% # *<SuperMDATravelAgent_method_addGroup.html
% SuperMDATravelAgent_method_addGroup>* : 
% # *<SuperMDATravelAgent_method_addPosition.html
% SuperMDATravelAgent_method_addPosition>* : 
% # *<SuperMDATravelAgent_method_addPositionGrid.html
% SuperMDATravelAgent_method_addPositionGrid>* : 
% # *<SuperMDATravelAgent_method_addSettings.html
% SuperMDATravelAgent_method_addSettings>* : 
% # *<SuperMDATravelAgent_method_changeAllGroup.html
% SuperMDATravelAgent_method_changeAllGroup>* : 
% # *<SuperMDATravelAgent_method_changeAllPosition.html
% SuperMDATravelAgent_method_changeAllPosition>* :
% # *<SuperMDATravelAgent_method_changeAllSettings.html
% SuperMDATravelAgent_method_changeAllSettings>* : 
% # *<SuperMDATravelAgent_method_createOrdinalLabels.html
% SuperMDATravelAgent_method_createOrdinalLabels>* :
% # *<SuperMDATravelAgent_method_dropGroup.html
% SuperMDATravelAgent_method_dropGroup>* :
% # *<SuperMDATravelAgent_method_dropGroupOrder.html
% SuperMDATravelAgent_method_dropGroupOrder>* :
% # *<SuperMDATravelAgent_method_dropPosition.html
% SuperMDATravelAgent_method_dropPosition>* :
% # *<SuperMDATravelAgent_method_dropPositionOrder.html
% SuperMDATravelAgent_method_dropPositionOrder>* :
% # *<SuperMDATravelAgent_method_dropSettings.html
% SuperMDATravelAgent_method_dropSettings>* : 
% # *<SuperMDATravelAgent_method_dropSettingsOrder.html
% SuperMDATravelAgent_method_dropSettingsOrder>* : 
% # *<SuperMDATravelAgent_method_refresh_gui_main.html
% SuperMDATravelAgent_method_refresh_gui_main>* :
% # *<SuperMDATravelAgent_object.html SuperMDATravelAgent_object>* :