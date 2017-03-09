macroscript MultiSlicer category: "Montelo Tools"
(
	try DestroyDialog MultiSlicerDialog catch()
	
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
			
			spinner slicingIntervalSpinner "Slicing Distance" range:[0,131072, 16] type:#worldunits height:25;
			
			checkbox constraintCheckBox "Constrained" align:#center;
			
			spinner slicingConstrainedCountSpinner "Slicing Count" range:[1,16384, 2] type:#integer height:25 enabled:false;
		)
		
		button sliceItButton "Slice It!" height:35 width:200;
		button debugButton "Debug It!" height:25 width:200;
		
		---------------------------------------------------------------------------------------------------------------
		----------------------------------------------------[CALLBACKS]--------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		
		---------------------
		----VARIABLES---
		---------------------
		
		local selectedObject = undefined;
		local slicingAxys = & slicingAxysRadio.state;
		local slicingPathLength = [0,0,0];
		local slicingConstrainedCount = slicingConstrainedCountSpinner.value;
		local slicingInterval = & slicingIntervalSpinner.value;
		
		function isSelecting =
		(
			selectedObject != undefined
		);
		
		function hasModifiers =
		(
			if selectedObject != undefined then
			(
				selectedObject.modifiers.count > 0;
			) else (
			false
			)
		);
		
		function warnNoSelection = 
		(
			if (not isSelecting()) do
			(
				messageBox("No object selected!");
			);
		);
		
		function evaluateSlicingPathLength = 
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
		);
		
		function evaluateSlicePlacement =
		(
			slicePlacementSpinner.value / 100;
		)
		
		function evaluateSlicingPosition indexInterval: selectedObject.modifiers.count = 
		(
			slicingPosition = [0,0,0];
			additionalSlicingInterval = (*slicingInterval) * (indexInterval - 1);
			
			slicingPosition[*slicingAxys] = (slicingPathLength[*slicingAxys] * evaluateSlicePlacement()) + selectedObject.min[*slicingAxys];
			slicingPosition[*slicingAxys] += 	additionalSlicingInterval;
			
			slicingPosition;
		);
		
		function clearModifiers =
		(
			if hasModifiers() do
			(
				modifiersCount = selectedObject.modifiers.count;
				suspendEditing();
				for index = 1 to modifiersCount do
				(
					deleteModifier selectedObject 1;
				)
				resumeEditing();
			)
		);
		
		function addSlice = 
		(
			if isSelecting() do
			(
				addModifier selectedObject (SliceModifier());
				selectedObject.modifiers[1].Slice_Plane.rotation = slicingOrientation[*slicingAxys];
				selectedObject.modifiers[1].Slice_Plane.pos = evaluateSlicingPosition();
			)
		);
		
		function iterateSlice =
		(
			if isSelecting() do
			(
				clearModifiers();
			
				slicingCount = slicingPathLength[*slicingAxys] - ( slicingPathLength[*slicingAxys] * evaluateSlicePlacement() );
				slicingCount = (slicingCount /  *slicingInterval) as integer;
			
				suspendEditing();
				for i = 0 to slicingCount do
				(
					addSlice();
				)
				resumeEditing();
			)
		)
			
		on objectSelectionButton pressed do
		(
			if selection.count == 1 then
			(
				selectedObject = selection[1];
				objectSelectionButton.text = selectedObject.name;
				slicingPathLength = evaluateSlicingPathLength();
			) else (
				selectedObject = undefined;
				objectSelectionButton.text = objectSelectionButtonText;
				slicingPathLength = [0,0,0];
			)
		)
		
		on slicingAxysRadio changed toNewValue do
		(
			
		)
		
		on slicePlacementSpinner changed toNewValue do
		(
			
		)
		
		on slicingIntervalSpinner changed toNewValue do
		(
			
		)
		
		on constraintCheckBox changed toNewValue do
		(
			
		)
		
		on slicingConstrainedCountSpinner changed toNewValue do
		(
			
		)
		
		on sliceItButton pressed do
		(			
			warnNoSelection();
			iterateSlice();
		)
		
		on MultiSlicerDialog open do
		(
			
		)
		
		on MultiSlicerDialog close do
		(
			clearModifiers();
		)
		
		on debugButton pressed do
		(
			
		)
		
	)
	
	CreateDialog MultiSlicerDialog 218 320 0 224;

)