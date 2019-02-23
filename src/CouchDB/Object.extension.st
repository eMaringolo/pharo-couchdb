Extension { #name : #Object }

{ #category : #'*CouchDB' }
Object >> couchToObject [
]

{ #category : #'*CouchDB' }
Object >> jsonInstanceVariableNames [
	^self class allInstVarNames
]

{ #category : #'*CouchDB' }
Object >> jsonKeysAndValuesDo: aBlock [
	aBlock value: '+class' value: self class fullName.
	self jsonInstanceVariableNames keysAndValuesDo: [:index :key | aBlock value: key value: (self instVarAt: index)]
]

{ #category : #'*CouchDB' }
Object >> jsonWriteOn: aStream [
	" We add the property +class to the hash because CouchDB uses the _ underscore convention for special properties. "

	| needsComma |
	needsComma := false.
	aStream nextPutAll: '{'.
	self jsonKeysAndValuesDo: [:key :value |
		needsComma ifFalse: [needsComma := true] ifTrue: [aStream nextPutAll: ','].
		key jsonWriteOn: aStream.
		aStream nextPutAll: ':'.
		value jsonWriteOn: aStream].
	aStream nextPutAll: '}'
]
