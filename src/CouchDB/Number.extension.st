Extension { #name : #Number }

{ #category : #'*CouchDB' }
Number >> couchWriteOn: aStream [
	self asFloat printOn: aStream 
]
