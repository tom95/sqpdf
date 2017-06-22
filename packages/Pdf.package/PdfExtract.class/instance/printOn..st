as yet unclassified
printOn: aStream

	aStream
		nextPutAll: 'PdfExtract(';
		nextPutAll: (self text truncateWithElipsisTo: 30);
		nextPut: $)