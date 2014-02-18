mm = Core_MicroManagerHandle;
stgmap = StageMap_gui_main('mm',mm);
smda = SuperMDALevel1Primary(mm);
SuperMDA_gui_main('SuperMDA',smda);