as yet unclassified
primitiveRenderPage

	<var: #strPtr type: 'char *'>
	<var: #dest type: 'char *'>
	<var: #buffer type: 'char *'>
	<export: true>

	| strLen strPtr strValue pageNumber success bitmap height stride width depth buffer dest out dpiNumber |
	interpreterProxy methodArgumentCount = 3 ifFalse: [^ interpreterProxy primitiveFailFor: 100].
	
	strValue := interpreterProxy stackValue: 2.
	((interpreterProxy isBytes: strValue) or: [interpreterProxy isWords: strValue])
		ifFalse: [^ interpreterProxy primitiveFailFor: 105].
	strPtr := interpreterProxy firstIndexableField: strValue.
	strLen := interpreterProxy byteSizeOf: strValue.
	
	stride := 0.
	height := 0.
	width := 0.
	depth := 0.
	buffer := 0.
	pageNumber := interpreterProxy stackIntegerValue: 1.
	dpiNumber := interpreterProxy stackIntegerValue: 0.
	
	interpreterProxy failed ifTrue: [^ interpreterProxy primitiveFailFor: 108].
	
	success := self cCode: 'render_page(strPtr, strLen, pageNumber, dpiNumber, &stride, &width, &height, &depth, &buffer)' inSmalltalk: [0].
	
	success < 0 ifTrue: [^ interpreterProxy primitiveFailFor: 110 - success].
	interpreterProxy failed ifTrue: [^ interpreterProxy primitiveFailFor: 107].
	
	bitmap := interpreterProxy instantiateClass: interpreterProxy classBitmap indexableSize: stride * height.
	bitmap ifNil: [^ interpreterProxy primitiveFailFor: stride * height].
	
	interpreterProxy failed ifTrue: [^ interpreterProxy primitiveFailFor: 109].
	
	dest := self cCoerce: (interpreterProxy firstIndexableField: bitmap) to: 'char *'.
	0 to: stride * height - 1 do: [:i | dest at: i put: (buffer at: i)].
	
	self cCode: 'free(buffer)' inSmalltalk: [].
	
	out := interpreterProxy instantiateClass: interpreterProxy classArray indexableSize: 4.
	interpreterProxy storePointer: 0 ofObject: out withValue: bitmap.
	interpreterProxy storePointer: 1 ofObject: out withValue: (interpreterProxy integerObjectOf: width).
	interpreterProxy storePointer: 2 ofObject: out withValue: (interpreterProxy integerObjectOf: height).
	interpreterProxy storePointer: 3 ofObject: out withValue: (interpreterProxy integerObjectOf: depth).
	
	^ interpreterProxy
		pop: interpreterProxy methodArgumentCount + 1
		thenPush: out