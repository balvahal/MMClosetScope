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
% maintains the fidelity of the intinerary while adding a new position to a
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