Extension { #name : #String }

{ #category : #'*CouchDB' }
String >> couchWriteOn: aStream [

	aStream nextPut: $".
	aStream nextPutAll: self.
	aStream nextPut: $"
]
