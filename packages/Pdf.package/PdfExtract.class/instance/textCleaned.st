as yet unclassified
textCleaned

	^ String streamContents: [:stream |
			text lines do: [:line |
				" empty line is likely paragraph separator "
				line
					ifEmpty: [stream nextPut: Character cr]
					ifNotEmpty: [
						" indent for a paragraph start? "
						(self leadingSeparators: line) > 2 ifTrue: [stream cr].
						
						" take a guess at hyphens "
						(line last = $- and: [(line at: line size - 1) isSeparator not])
							ifTrue: [stream nextPutAll: line allButLast]
							ifFalse: [stream nextPutAll: line; space]]]]