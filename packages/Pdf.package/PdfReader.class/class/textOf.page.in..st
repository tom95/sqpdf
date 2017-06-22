as yet unclassified
textOf: aFilenameString page: aPageNumber in: aRectangle

	^ self primTextOf: aFilenameString page: aPageNumber - 1 x: aRectangle left y: aRectangle top width: aRectangle width height: aRectangle height