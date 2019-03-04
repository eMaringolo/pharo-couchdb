"
I'm an utility class created with the purpose of not cluttering other classes with helper methods.
"
Class {
	#name : #CouchJSONWriter,
	#superclass : #Object,
	#category : #'CouchDB-Core-CouchDB-Core'
}

{ #category : #'character-encoding' }
CouchJSONWriter class >> doesCodePointNeedEscaping: code [
	code < 32 ifTrue: [ ^ true ].
	( code = 34 or: [ code = 92 ]) ifTrue: [ ^ true ].
	^code > 126
]

{ #category : #'character-encoding' }
CouchJSONWriter class >> escapeChar: codePoint on: writeStream [

	codePoint = 34
		ifTrue: [ ^ writeStream nextPutAll: '\"' ].
	codePoint = 92
		ifTrue: [ ^ writeStream nextPutAll: '\\' ].
	codePoint = 47
		ifTrue: [ ^ writeStream nextPutAll: '\/' ].
	codePoint = 8
		ifTrue: [ ^ writeStream nextPutAll: '\b' ].
	codePoint = 12
		ifTrue: [ ^ writeStream nextPutAll: '\f' ].		
	codePoint = 10
		ifTrue: [ ^ writeStream nextPutAll: '\n' ].		
	codePoint = 13
		ifTrue: [ ^ writeStream nextPutAll: '\r' ].		
	codePoint = 9
		ifTrue: [ ^ writeStream nextPutAll: '\t' ].	
		
	self escapeUnicode: codePoint on: writeStream
]

{ #category : #'character-encoding' }
CouchJSONWriter class >> escapeUnicode4: codePoint on: writeStream [
	writeStream nextPutAll: '\u'.
	codePoint printOn: writeStream base: 16 nDigits: 4
]

{ #category : #'character-encoding' }
CouchJSONWriter class >> escapeUnicode: codePoint on: writeStream [

	codePoint <= 16rFFFF
		ifTrue: [ self escapeUnicode4: codePoint on: writeStream ]
		ifFalse: [ 
			codePoint <= 16r10FFFF
				ifTrue: [ | leadSurrogate trailSurrogate shifted |
					"Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair"
					"See https://tools.ietf.org/html/rfc7159#section-7"
					shifted := codePoint - 16r10000.
					leadSurrogate := 16rD800 + (shifted // 16r400).
					trailSurrogate := 16rDC00 + (shifted \\ 16r400).
					self escapeUnicode4: leadSurrogate on: writeStream.
					self escapeUnicode4: trailSurrogate on: writeStream]
				ifFalse: [ self error: 'Character Unicode code point outside encoder range' ] ]
]

{ #category : #writing }
CouchJSONWriter class >> writeChar: char on: writeStream [

	| codePoint |
	codePoint := char codePoint.
	(self doesCodePointNeedEscaping: codePoint)
		ifTrue: [ self escapeChar: codePoint on: writeStream ]
		ifFalse: [ writeStream nextPut: char ]
]

{ #category : #writing }
CouchJSONWriter class >> writeString: aString on: aStream [
	aStream nextPut: $".
	aString do: [ :char | self writeChar: char on: aStream ].
	aStream nextPut: $"
]
