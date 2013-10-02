%%
%
classdef SuperMDAPosition
    %%
    % * xyz: the location of the position in an array *[x, y, z]*. The
    % units are micrometers.
    properties
        xyz
        settings
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mmhandle
        function obj = SuperMDAPosition(mmhandle, my_xyz, my_settings)
            if nargin == 0
                return
            elseif nargin == 1
                obj.xyz = mmhandle.pos;
                obj.settings = SuperMDAPositionSettings(mmhandle);
                return
            end
        end
    end
end