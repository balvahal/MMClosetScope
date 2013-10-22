function mmhandle = set_position(mmhandle)
mmhandle.SuperMDA.group.position(end+1) = mmhandle.SuperMDA.group.position(end).copy_position;
mmhandle = Core_general_getXYZ(mmhandle);
mmhandle.SuperMDA.group.position(end).xyz = mmhandle.pos;
mmhandle.SuperMDA.group.position(end).continuous_focus_offset = mmhandle.core.getAutoFocusOffset;
end