accessing
fixedSelection
	" flip origin and corner of our selection such that it will be a valid rectangle again "
	
	^ (activeSelection origin x > activeSelection corner x or: [activeSelection origin y > activeSelection corner y])
		ifTrue: [activeSelection corner corner: activeSelection origin]
		ifFalse: [activeSelection]