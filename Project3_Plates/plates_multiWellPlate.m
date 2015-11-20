%% plates_multiWellPlate
%
classdef plates_multiWellPlate < handle
    %%
    %
    properties
        ULC
        URC
        LLC
        mm
        colnum
        rownum
        registrationBool = false;
        guiBool = true;
    end
    
    properties (SetAccess = protected)
        x_vector
        y_vector
        plate_height
        plate_width
        well_width
        well_height
    end
    
    properties (Hidden = true)
        
    end
    methods
        %% The constructor
        %
        function obj = plates_multiWellPlate(mm)
            if nargin == 0
                return
            end
            obj.mm = mm;
        end
        %%
        %
        function obj = registration(obj)
            obj.registrationBool = false;
            if obj.guiBool
                myoutput = plates_registration(obj.mm);
                if isempty(myoutput)
                    return
                end
                obj.ULC = myoutput.ULC;
                obj.URC = myoutput.URC;
                obj.LLC = myoutput.LLC;
                obj.rownum = myoutput.rownum;
                obj.colnum = myoutput.colnum;
            else
                myoutput = obj.vectors(obj.ULC,obj.URC,obj.LLC,obj.rownum,obj.colnum);
            end
            obj.x_vector = myoutput.x_vector;
            obj.y_vector = myoutput.y_vector;
            obj.plate_height = myoutput.plate_height;
            obj.plate_width = myoutput.plate_width;
            obj.well_width = myoutput.well_width;
            obj.well_height = myoutput.well_height;
            obj.registrationBool = true;
        end
        %%
        %
        function obj = save(obj,mypath)
            
        end
        %%
        %
        function obj = load(obj,mypath)
            
        end
    end
    
    methods (Static)
        %% vectors
        % When a multi-well plate is placed on the microscope the spatial
        % orientation needs to be registered. This registration is needed
        % to determine the orientation relative to the stage movement in
        % (X,Y) and if the there is any slope in the (Z).
        %
        % Each point represents the center of a well.
        %
        % * ULC = upper left corner (x,y,z)
        % * URC = upper right corner (x,y,z)
        % * LLC = lower left corner (x,y,z)
        function myoutput = vectors(ULC, URC, LLC, rownum, colnum)
            %%
            % Use three points to define a plane that represents the
            % multi-well plate. The ULC is the origin. With reference to
            % looking at a multi-well plate from overhead. Positive
            % x-movement is from left to right. Positive y-movement is from
            % top to bottom.
            %
            % The vectors will be have a unity magnitude.
            x_vector = URC - ULC;
            myoutput.plate_width = sqrt(sum(x_vector.^2));
            myoutput.x_vector = x_vector/myoutput.plate_width;
            y_vector = LLC - ULC;
            myoutput.plate_height = sqrt(sum(y_vector.^2));
            myoutput.y_vector = y_vector/myoutput.plate_height;
            %%%
            % These vectors will define a plane with a normal vector of
            % |cross(x_vector,y_vector)|.
            %
            % Calculate the distance between well-centers in both x and y
            myoutput.well_width = myoutput.plate_width/colnum;
            myoutput.well_height = myoutput.plate_height/rownum;
        end
    end
end