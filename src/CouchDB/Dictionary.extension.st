Extension { #name : #Dictionary }

{ #category : #'*CouchDB' }
Dictionary >> couchToObject [
	| class object |
	self removeKey: '_id' ifAbsent: [].
	self removeKey: '_rev' ifAbsent: [].
	self keysAndValuesDo: [:key :value | self at: key put: value couchToObject].
	class := (self at: '+class' ifAbsent: [^self]) asStrictReference valueOrDo: [^self].
	object := class basicNew.
	object jsonInstanceVariableNames keysAndValuesDo: [:index :key |
		self at: key ifPresent: [:value | object instVarAt: index put: value]].
	^object
]

{ #category : #'*CouchDB' }
Dictionary >> jsonKeysAndValuesDo: aBlock [
	self keysAndValuesDo: aBlock
]
