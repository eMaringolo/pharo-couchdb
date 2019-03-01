Extension { #name : #Character }

{ #category : #'*CouchDB' }
Character >> couchWriteOn: aStream [

	aStream nextPut: $".
	aStream nextPut: self.
	aStream nextPut: $"
]
