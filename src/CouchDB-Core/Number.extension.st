Extension { #name : #Number }

{ #category : #'*CouchDB-Core' }
Number >> couchWriteOn: aStream [
	self asFloat printOn: aStream 
]
