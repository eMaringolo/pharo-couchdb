Extension { #name : #UndefinedObject }

{ #category : #'*CouchDB-Core' }
UndefinedObject >> couchWriteOn: aStream [
	aStream nextPutAll: 'null'
]
