--Multi Slicer | version 1.0;

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
		local previousModifiersCount = 0;
		
		function isConstrained =
		(
			constraintCheckBox.checked;
		)
		
		function isSelecting =
		(
			(selectedObject != undefined and isValidNode selectedObject);
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
		
		function setSliceDialogBox =
		(
			selectedObject = selection[1];
			objectSelectionButton.text = selectedObject.name;
			slicingPathLength = evaluateSlicingPathLength();
			previousModifiersCount = selectedObject.modifiers.count;
		);
		
		function resetSliceDialogBox = 
		(
			selectedObject = undefined;
			objectSelectionButton.text = objectSelectionButtonText;
			slicingPathLength = [0,0,0];
			previousModifiersCount = 0;
		);
		
		function warnNoSelection = 
		(
			if (not isSelecting()) do
			(
				messageBox("No object selected!");
				resetSliceDialogBox();
			);
		);
		
		function evaluateSlicePlacement =
		(
			slicePlacementSpinner.value / 100;
		);
		
		function evaluateSlicingPosition indexInterval: (selectedObject.modifiers.count - previousModifiersCount) = 
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
				modifiersCount = selectedObject.modifiers.count - previousModifiersCount;
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
				
				if (isConstrained() and slicingConstrainedCount < slicingCount)  do
				(
					slicingCount = slicingConstrainedCount;
				)
				
				suspendEditing();
				for i = 1 to slicingCount do
				(
					addSlice();
				)
				resumeEditing();
			)
		);
			
		on objectSelectionButton pressed do
		(
			if selection.count == 1 then
			(
				setSliceDialogBox();
			) else (
				resetSliceDialogBox();
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
			slicingConstrainedCountSpinner.enabled = toNewValue;
			slicingConstrainedCount = slicingConstrainedCountSpinner.value;
			print slicingConstrainedCount;
		)
		
		on slicingConstrainedCountSpinner changed toNewValue do
		(
			slicingConstrainedCount = toNewValue;
			print slicingConstrainedCount;
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
		
	)
	
	CreateDialog MultiSlicerDialog 218 320 0 224;

)