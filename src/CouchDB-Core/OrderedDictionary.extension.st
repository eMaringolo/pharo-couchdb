Extension { #name : #OrderedDictionary }

{ #category : #'*CouchDB-Core' }
OrderedDictionary >> couchWriteOn: aStream [
	self basicCouchWriteOn: aStream writeClass: false
]
