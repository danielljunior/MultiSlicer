macroscript MultiSlicer category: "Montelo Tools"
(
	try(DestroyDialog MultiSlicerDialog) catch();

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
			
			spinner slicingInterval "Slicing Distance" range:[0,131072, 16] type:#worldunits height:25;
			
			checkbox constraintCheckBox "Constrained" align:#center;
			
			spinner slicingCount "Slicing Count" range:[1,16384, 2] type:#integer height:25 enabled:false;
		)
		
		button sliceItButton "Slice It!" height:35 width:200;
		
		---------------------------------------------------------------------------------------------------------------
		----------------------------------------------------[CALLBACKS]--------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		
		on objectSelectionButton pressed do
		(
			
		)
		
		on slicingAxys changed toNewValue do
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
			print MultiSlicerDialog;
		)
		
		on MultiSlicerDialog close do
		(
			
		)

	)
	
	CreateDialog MultiSlicerDialog 218 320 0 224;

)