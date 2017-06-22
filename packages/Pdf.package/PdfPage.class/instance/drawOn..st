drawing
drawOn: aCanvas

	super drawOn: aCanvas.
	
	activeSelection ifNotNil: [
		aCanvas fillRectangle: self fixedSelection fillStyle: (Color blue alpha: 0.3)]