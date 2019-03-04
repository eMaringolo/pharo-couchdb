Extension { #name : #Dictionary }

{ #category : #'*CouchDB-Core' }
Dictionary >> couchKeysAndValuesDo: aBlock [
	self keysAndValuesDo: aBlock
]

{ #category : #'*CouchDB-Core' }
Dictionary >> couchToObject [
	| class className object |
	#('id' 'rev' 'attachments')
		do: [ :key | self removeKey: '_' , key ifAbsent: [  ] ].

	"self keysAndValuesDo: [ :key :value | self at: key put: value couchToObject  ]."
	className := self at: '+class' ifAbsent: [ ^ self ].
	class := self class environment at: className asSymbol.
	object := class basicNew.
	object couchDocumentProperties
		keysAndValuesDo: [ :key :each | 
			self
				at: key
				ifPresent:
					[ :keyValue | object perform: each asMutator with: keyValue couchToObject ] ].
	^ object
]

{ #category : #'*CouchDB-Core' }
Dictionary >> couchWriteOn: aStream [
	self basicCouchWriteOn: aStream writeClass: false
]
