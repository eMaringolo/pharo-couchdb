Extension { #name : #Boolean }

{ #category : #'*CouchDB-Core' }
Boolean >> couchWriteOn: aStream [
	self printOn: aStream
]
