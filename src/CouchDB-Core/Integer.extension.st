Extension { #name : #Integer }

{ #category : #'*CouchDB-Core' }
Integer >> couchWriteOn: aStream [
	self printOn: aStream 
]
