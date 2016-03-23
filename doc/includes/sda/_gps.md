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

![](images/gps-hierarchy.png)