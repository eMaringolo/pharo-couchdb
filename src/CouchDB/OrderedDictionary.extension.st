Extension { #name : #OrderedDictionary }

{ #category : #'*CouchDB' }
OrderedDictionary >> couchWriteOn: aStream [
	self basicCouchWriteOn: aStream writeClass: false
]
