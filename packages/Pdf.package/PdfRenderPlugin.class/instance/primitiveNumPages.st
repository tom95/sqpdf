as yet unclassified
primitiveNumPages

	<var: #strPtr type: 'char *'>
	<export: true>

	| num strLen strPtr strValue |
	interpreterProxy methodArgumentCount = 1 ifFalse: [^ interpreterProxy primitiveFailFor: 100].
	
	strValue := interpreterProxy stackValue: 0.
	((interpreterProxy isBytes: strValue) or: [interpreterProxy isWords: strValue])
		ifFalse: [ ^interpreterProxy primitiveFailFor: 105 ].
	strPtr := interpreterProxy firstIndexableField: strValue.
	strLen := interpreterProxy byteSizeOf: strValue.
	
	num := self cCode: 'num_pages(strPtr, strLen)' inSmalltalk: [0].
	
	^ interpreterProxy
		pop: interpreterProxy methodArgumentCount + 1
		thenPush: (interpreterProxy integerObjectOf: num)