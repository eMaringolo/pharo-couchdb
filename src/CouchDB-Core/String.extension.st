Extension { #name : #String }

{ #category : #'*CouchDB-Core' }
String >> couchWriteOn: aStream [
	CouchJSONWriter writeString: self on: aStream
]
