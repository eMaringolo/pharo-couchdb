Extension { #name : #UndefinedObject }

{ #category : #'*CouchDB' }
UndefinedObject >> couchWriteOn: aStream [
	aStream nextPutAll: 'null'
]
