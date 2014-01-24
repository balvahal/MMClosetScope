classdef SuperMDA_event_database_updated < event.EventData
   properties
      I
   end

   methods
      function data = SuperMDA_event_database_updated(mmhandle)
         data.I = mmhandle.I;
      end
   end
end