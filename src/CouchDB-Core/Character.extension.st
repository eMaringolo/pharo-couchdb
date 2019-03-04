Extension { #name : #Character }

{ #category : #'*CouchDB-Core' }
Character >> couchWriteOn: aStream [

	aStream nextPut: $".
	aStream nextPut: self.
	aStream nextPut: $"
]
