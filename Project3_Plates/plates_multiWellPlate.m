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
            if obj.guiBool
                myoutput = plates_registration(obj.mm);
                if isempty(myoutput)
                    obj.registrationBool = false;
                    return
                end
            else
                myoutput = obj.vectors(obj.ULC,obj.URC,obj.LLC);
            end
            
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
        function myoutput = vectors(ULC, URC, LLC)
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
            
        end
    end
end