Extension { #name : #SequenceableCollection }

{ #category : #'*CouchDB-Core' }
SequenceableCollection >> couchToObject [
	^self collect: [:each | each couchToObject]
]
