as yet unclassified
formFor: aFilenameString page: aPageNumber dpi: aDpiNumber

	| data |
	data := self
		retryWithGC: [self primRender: aFilenameString page: aPageNumber - 1 dpi: aDpiNumber]
		until: [:code | code ~= 111].
	
	^ Form extent: data second @ data third depth: data fourth bits: data first