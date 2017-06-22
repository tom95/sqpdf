event handling
mouseUp: anEvent

	activeSelection ifNotNil: [
		activeSelection := activeSelection origin corner: anEvent position.
		
		self extractActiveSelection.
		
		activeSelection := nil.
		self changed]