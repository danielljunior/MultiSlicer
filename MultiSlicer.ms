macroscript MultiSlicer category: "Montelo Tools"
(
	try(DestroyDialog MultiSlicerDialog) catch();
	
	local objectSelectionButtonText = "Select Object and Click";
	local slicingOrientation = #((quat 0 0.707107 0 0.707107),(quat -0.707107 0 0 0.707107),(quat 0 0 0 1))

	Rollout MultiSlicerDialog "Multi Slicer"
	(
		---------------------------------------------------------------------------------------------------------------
		--------------------------------------------------[INTERFACE]---------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		
		group "Object Selection" 
		(
			button objectSelectionButton objectSelectionButtonText height:25 width:200;
			label objectSelectionLabel "";
		)
		
		group "Slicing Control"
		(
			label slicingAxysLabel "Slicing Axys";
			
			radiobuttons slicingAxysRadio labels:#("X","Y","Z") height:25;
			
			spinner slicePlacementSpinner "Slicing Placement" range:[0, 100, 50] type:#float height:25;
			
			spinner slicingInterval "Slicing Distance" range:[0,131072, 16] type:#worldunits height:25;
			
			checkbox constraintCheckBox "Constrained" align:#center;
			
			spinner slicingCount "Slicing Count" range:[1,16384, 2] type:#integer height:25 enabled:false;
		)
		
		button sliceItButton "Slice It!" height:35 width:200;
		
		---------------------------------------------------------------------------------------------------------------
		----------------------------------------------------[CALLBACKS]--------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		
		---------------------
		----VARIABLES---
		---------------------
		
		local selectedObject = undefined;
		local slicingAxys = slicingAxysRadio.state;
		local slicingPath = [0,0,0];
		
		function isSelecting =
		(
			selectedObject != undefined
		);
		
		function evaluateSlicingPath = 
		(
			if isSelecting() do
			(
				slicingPathDistance = [0,0,0];
				for index = 1 to 3 do
				(
					slicingPathDistance[index] = selectedObject.max[index] - selectedObject.min[index];
				)
				slicingPathDistance;
			)
		)
		
		function addSlice = 
		(
			if isSelecting() do
			(
				addModifier selectedObject SliceModifier;
				selectedObject.modifiers[1].Slice_Plane.rotation = slicingOrientation[slicingAxys];
			)
		)

		on objectSelectionButton pressed do
		(
			if selection.count == 1 then
			(
				selectedObject = selection[1];
				objectSelectionButton.text = selectedObject.name;
				slicingPath = evaluateSlicingPath();
				
				print slicingPath;
			) else (
				selectedObject = undefined;
				objectSelectionButton.text = objectSelectionButtonText;
				slicingPath = [0,0,0];
			)
		)
		
		on slicingAxysRadio changed toNewValue do
		(
			
		)
		
		on slicePlacementSpinner changed toNewValue do
		(
			
		)
		
		on slicingInterval changed toNewValue do
		(
			
		)
		
		on constraintCheckBox changed toNewValue do
		(
			
		)
		
		on slicingCount changed toNewValue do
		(
			
		)
		
		on sliceItButton pressed do
		(			
			
		)
		
		on MultiSlicerDialog open do
		(
			
		)
		
		on MultiSlicerDialog close do
		(
			
		)

	)
	
	CreateDialog MultiSlicerDialog 218 320 0 224;

)