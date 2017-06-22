as yet unclassified
leadingSeparators: aString

	| leadingSeparators |
	leadingSeparators := 0.
	
	aString do: [:char |
		char isSeparator
			ifTrue: [leadingSeparators := leadingSeparators + 1]
			ifFalse: [^ leadingSeparators]].
		
	^ leadingSeparators