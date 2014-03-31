%%
%
function [obj] = super_mda_method_finalize_MDA(obj)
%% Update the dependent parameters in the MDA object
% Some parameters in the MDA object are dependent on others.
% This dependency came about from combining parameters that are
% easy to configure by a user interface into data structures
% that are convenient to code with.
%
% This function serves as quality control to ensure that there are not any
% descrepencies or logical falicies contained with the SuperMDA object. It
% is also a convenience function, because it executes a series of
% methods/functions that have been created to facilitate the creation and
% manipulation of the SuperMDA itinerary.
%% Should there be a check on the |order| properties
%
% if isempty(obj.group_order) || ...
%         ~isempty(setdiff(obj.group_order,(1:obj.my_length))) || ...
%         length(obj.group_order)~=obj.my_length
%     obj.group_order = (1:obj.my_length);
% end
%% Convert function names into function handles and add labels
% For flexibiility purposes, special functions have two properties: a name
% and a function handle. The name makes it easier to interact with from a
% debugging/user interface stand point. The handle is the necessary code
% element that implements the desired function. The following loop
% structure makes sure these properties are consistent.
obj.update_smdaFunctions;
%% Update z-stack information
%
obj.update_zstack;
%% Pre-allocate the database
%
obj.preAllocateDatabaseAndInitialize