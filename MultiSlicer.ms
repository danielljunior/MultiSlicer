macroscript MultiSlicer category: "Montelo Tools"
(
	try(DestroyDialog MultiSlicerDialog)catch();
	
	local  axysRotations = #((quat 0 0.707107 0 0.707107), (quat -0.707107 0 0 0.707107), (quat 0 0 0 1));
	local selectedObject = undefined;
	local slicingPathLength = [0,0,0];
	local isSelected = false;
	local isPreviewing = false;

	Rollout MultiSlicerDialog "Multi Slicer"
	(
		---------------------------------------------------------------------------------------------------------------
		--------------------------------------------------[INTERFACE]---------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		
		group "Object Selection" 
		(
			button objectSelectionButton "Select Object and Click";
			label objectSelectionLabel "";
		)
		
		group "Slicing Control"
		(
			label slicingAxysLabel "Slicing Axys";
			
			radiobuttons slicingAxys labels:#("X","Y","Z") height:25;
			
			spinner slicePlacementSpinner "Slicing Placement" range:[0, 100, 50] type:#float height:25;
			
			spinner slicingDistance "Slicing Distance" range:[0,131072, 16] type:#worldunits height:25;
			
			checkbox constraintCheckBox "Constrained" align:#center;
			
			spinner slicingCount "Slicing Count" range:[1,16384, 2] type:#integer height:25 enabled:false;
		)
		
		button sliceItButton "Slice It!" height:35 width:200;
		
		---------------------------------------------------------------------------------------------------------------
		----------------------------------------------------[CALLBACKS]--------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		
		function updateSlicingPathLength =
		(
			for axys = 1 to 3 do
			(
				slicingPathLength[axys] = selectedObject.max[axys] - selectedObject.min[axys];
			)
		)
		
		function updateAxysPosition actualAxys: slicingAxys.state =
		(
			if isPreviewing do
			(
				axysPosition = [0,0,0];
				axysPosition[actualAxys] = (slicingPathLength[actualAxys] * (slicePlacementSpinner.value/100.0) + selectedObject.min[actualAxys]);
				selectedObject.modifiers[1].Slice_Plane.pos = axysPosition;
			)
			
			return axysPosition;
		)
		
		function updateSlicingRotation =
		(
			selectedObject.modifiers[1].Slice_Plane.rotation = axysRotations[slicingAxys.state];
			return axysRotations[slicingAxys.state];
		)
		
		on slicingAxys changed toNewValue do
		(
			updateAxysPosition(toNewValue);
			updateSlicingRotation();
		)
		
		on objectSelectionButton pressed do
		(
			if selection.count == 1 then
			(
				objectSelectionButton.text = selection[1].name;
				selectedObject = $;
				isSelected = true;
				objectSelectionLabel.text = "To clear unselect all and reclick!";
				updateSlicingPathLength();
			)
			else
			(
				objectSelectionButton.text = "Select Object and Click";
				selectedObject = $;
				isSelected = false;
				objectSelectionLabel.text = "";
				slicingPathLength = [0,0,0];
			)
		)
		
		on sliceItButton pressed do
		(			
			if isSelected do
			(
				slicingAmount = ceil(slicingPathLength[slicingAxys.state]/slicingDistance.value) as integer;
				
				addModifier selectedObject (SliceModifier());
					
				isPreviewing = true;
				
				updateSlicingRotation();
				
				updateAxysPosition();
			)
			
			/*if isSelected do
			(
				addModifier selectedObject (SliceModifier());
					
				isPreviewing = true;
				
				selectedObject.modifiers[1].Slice_Plane.rotation = axysRotations[slicingAxys.state];
				
				updateAxysPosition();
			)*/
		)
		
		on slicePlacementSpinner changed toNewValue do
		(
			updateAxysPosition();
		)
		
		on constraintCheckBox changed toNewValue do
		(
			slicingCount.enabled = constraintCheckBox.state;
		)
		
		
		on MultiSlicerDialog close do
		(
			if isPreviewing do
			(
				for modifierObject in selectedObject.modifiers do
				(
					for i=1 to selectedObject.modifiers.count do deleteModifier selectedObject 1;
				)
			)
		)
		---------------------------------------------------------------------------------------------------------------
		--------------------------------------------------[DEBUG]--------------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		
		/*label debugLabel "Debug" offset:[0,30];
		
		button debugButton "Click to debug!";
		
		on debugButton pressed do
		(
			print "Selection Flag is";
			print isSelected;
			print selectedObject;
			
			if not isSelected do
			(
				assert_equal objectSelectionButton.text "Select Object and Click";
				assert_equal selectedObject undefined;
				assert_false isSelected;
				assert_equal objectSelectionLabel.text "";
			)
			
			if isSelected do
			(
				assert_not_equal objectSelectionButton.text "Select Object and Click";
				assert_not_equal selectedObject undefined;
				assert_true isSelected;
				assert_equal objectSelectionLabel.text "To clear unselect all and reclick!";
			)
		)*/
	)
	
	CreateDialog MultiSlicerDialog 218 320 0 224;

)