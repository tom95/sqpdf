as yet unclassified
primitiveTextOfPage

	<var: #strPtr type: 'char *'>
	<var: #text type: 'char *'>
	<var: #dest type: 'char *'>
	<export: true>

	| strLen strPtr strValue h w x y dest resultOop text textLen pageNum |
	interpreterProxy methodArgumentCount = 6 ifFalse: [^ interpreterProxy primitiveFailFor: 100].
	
	strValue := interpreterProxy stackValue: 5.
	((interpreterProxy isBytes: strValue) or: [interpreterProxy isWords: strValue])
		ifFalse: [ ^interpreterProxy primitiveFailFor: 105 ].
	strPtr := interpreterProxy firstIndexableField: strValue.
	strLen := interpreterProxy byteSizeOf: strValue.
	
	pageNum := interpreterProxy stackIntegerValue: 4.
	x := interpreterProxy stackIntegerValue: 3.
	y := interpreterProxy stackIntegerValue: 2.
	w := interpreterProxy stackIntegerValue: 1.
	h := interpreterProxy stackIntegerValue: 0.
	
	interpreterProxy failed ifTrue: [interpreterProxy primitiveFailFor: 103].
	
	text := self cCode: 'text_of_page(strPtr, strLen, pageNum, x, y, w, h)' inSmalltalk: [0].
	text = 0 ifTrue: [interpreterProxy primitiveFailFor: 104].
	textLen := self cCode: 'strlen(text)' inSmalltalk: [0].
	
	resultOop := interpreterProxy instantiateClass: interpreterProxy classString indexableSize: textLen.
	dest := self cCoerce: (interpreterProxy firstIndexableField: resultOop) to: 'char *'.
	0 to: textLen - 1 do: [:i | dest at: i put: (text at: i)].
	self cCode: 'free(text)' inSmalltalk: [].
	
	^ interpreterProxy
		pop: interpreterProxy methodArgumentCount + 1
		thenPush: resultOop