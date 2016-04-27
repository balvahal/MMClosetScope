# GPS: Group, Position, Settings
The organization of the multi-dimensional-acquisition is encompassed within the GPS hierarchy, which is the relationship between groups, positions, and settings.

* Group: a collection of positions
* Position: a collection of settings in addition to the (x,y,z) of a motorized stage, objective, and Perfect Focus System by Nikon.
* Settings: the parameters and variables that describe the imaging conditions of the microscope. The settings also specifiy z-stacks.

The relationship between each layer of the GPS conforms to the following rules:

* A valid Group must contain at least 1 Position and all Positions must be valid.
* A valid Position must contain at least 1 Settings. A Position is not valid if it is not contained within a group.
* A Settings is valid if it is contained within at least 1 Position.
* Positions and Settings can belong to multiple Groups and Positions, respectively.
* The default order of acquisition is the order of creation. Groups have priority over Positions.
* Duplicate Positions and Settings cannot be contained within unique Groups and Positions, respectively.

![A visualization of the GPS hierarchy](images/gps-hierarchy.png)

When the SDA is executed, the order of events is determined by 5 functions that can be customized for each Group, Position, or Settings. GPS hierarchy, or tree, is travered depth-first. Starting with the first Group all of its Positions are executed before moving to the next Group. Additionally, within each Position all of its Settings are executed before moving on to the next Position. Importantly, Groups and Positions have 2 functions each: one the triggers just before changing to a Group or Position and another just after leaving a Group or Position. Settings have a single function.

![A visualization of the execution of the SDA determined in the GPS](images/gps-function.png)