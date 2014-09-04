function [] = SuperMDAPilot_gui_main_pushbutton_begin_smda_Callback_infig(handles)
smda = handles.smda;
close(handles.gui_main);
smda.mm.core.enableDebugLog(1);
smda.start_acquisition;