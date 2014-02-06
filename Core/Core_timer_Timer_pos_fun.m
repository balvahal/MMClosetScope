function [mmhandle] = Core_timer_Timer_pos_fun(mmhandle)
mmhandle.getXYZ;
if ishandle(mmhandle.gui_StageMap)
    handles_gui_StageMap = guidata(mmhandle.gui_StageMap);
    handles_gui_StageMap.update(mmhandle.gui_StageMap);
end
end