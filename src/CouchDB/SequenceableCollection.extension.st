Extension { #name : #SequenceableCollection }

{ #category : #'*CouchDB' }
SequenceableCollection >> couchToObject [
	^self collect: [:each | each couchToObject]
]
