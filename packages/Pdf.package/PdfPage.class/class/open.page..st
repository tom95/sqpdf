as yet unclassified
open: aFilenameString page: aPageNumber

	^ self new
		filename: aFilenameString;
		pageNumber: aPageNumber;
		image: (PdfReader formFor: aFilenameString page: aPageNumber dpi: 144);
		yourself