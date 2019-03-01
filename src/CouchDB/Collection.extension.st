Extension { #name : #Collection }

{ #category : #'*CouchDB' }
Collection >> couchWriteOn: aStream [
	aStream nextPut: $[.
	self
		do: [ :each | each couchWriteOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $]
]
