Extension { #name : #Integer }

{ #category : #'*CouchDB' }
Integer >> couchWriteOn: aStream [
	self printOn: aStream 
]
