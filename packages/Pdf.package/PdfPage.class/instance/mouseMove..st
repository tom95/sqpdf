event handling
mouseMove: anEvent

	activeSelection ifNotNil: [
		activeSelection := activeSelection origin corner: anEvent position.
		self changed]