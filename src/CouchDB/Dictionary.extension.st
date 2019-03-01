Extension { #name : #Dictionary }

{ #category : #'*CouchDB' }
Dictionary >> couchKeysAndValuesDo: aBlock [
	self keysAndValuesDo: aBlock
]

{ #category : #'*CouchDB' }
Dictionary >> couchToObject [
	| class object |
	self removeKey: '_id' ifAbsent: [].
	self removeKey: '_rev' ifAbsent: [].
	self keysAndValuesDo: [:key :value | self at: key put: value couchToObject ].
	class := (self at: '+class' ifAbsent: [^self]) asClass.
	object := class basicNew.
	object couchKeysAndValuesDo: [:key :each |
		self at: key ifPresent: [:keyValue | object perform: each asMutator with: keyValue couchToObject]].
	^object
]

{ #category : #'*CouchDB' }
Dictionary >> couchWriteOn: aStream [
	self basicCouchWriteOn: aStream writeClass: false
]
