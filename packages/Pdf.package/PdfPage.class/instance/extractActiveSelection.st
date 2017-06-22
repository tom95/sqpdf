event handling
extractActiveSelection

	| rect |
	rect := self fixedSelection translateBy: self position negated.

	^ PdfExtract new
		text: (PdfReader
			textOf: self filename
			page: self pageNumber
			in: rect);
		form: (self image copy: rect);
		pageNumber: self pageNumber;
		filename: self filename;
		explore;
		yourself