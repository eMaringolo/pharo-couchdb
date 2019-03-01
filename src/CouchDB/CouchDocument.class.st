Class {
	#name : #CouchDocument,
	#superclass : #CouchObject,
	#instVars : [
		'revision',
		'object'
	],
	#category : #CouchDB
}

{ #category : #'instance creation' }
CouchDocument class >> with: anObject [
	^ self new
		object: anObject;
		yourself
]

{ #category : #'instance creation' }
CouchDocument class >> writeAttachment: uri contentType: aString bytes: aByteArray [
	^self request: [:client | 
		| request |
		request := (client requestClass put: uri).
		request contentType: aString.
		request doNotChunk.
		request contentLength: aByteArray size.
		request byteSource: aByteArray readStream.
		client request: request.
		client  executeAndGetResponse
	]
]

{ #category : #converting }
CouchDocument >> couchWriteOn: aStream [
	aStream nextPutAll: '{'.
	aStream nextPutAll: '"_id":'.
	self id couchWriteOn: aStream.
	self revision ifNotNil:
		[aStream nextPutAll: ',"_rev":'.
		self revision couchWriteOn: aStream].
	object couchKeysAndValuesDo: [:key :value |
		aStream nextPutAll: ','.
		key couchWriteOn: aStream.
		aStream nextPutAll: ':'.
		value couchWriteOn: aStream].
	aStream nextPutAll: '}'
]

{ #category : #api }
CouchDocument >> delete [
	| response |
	revision ifNil: [self refresh].
	response := self class delete: (address copy queryAt: 'rev' put: revision).
	revision := response at: 'rev'.
	^response
]

{ #category : #accessing }
CouchDocument >> id [
	^ self address ifNotNil: [ :obj | obj lastPathSegment ]
]

{ #category : #'initialize-release' }
CouchDocument >> initialize [
	super initialize.
	object := self undefined
]

{ #category : #accessing }
CouchDocument >> object [
	
	object = #_undefined ifTrue: [ self refresh ].
	^object
]

{ #category : #accessing }
CouchDocument >> object: anObject [
	object := anObject
]

{ #category : #printing }
CouchDocument >> printOn: aStream [
	super printOn: aStream.
	revision ifNil: [^self].
	aStream space; nextPutAll: revision
]

{ #category : #api }
CouchDocument >> refresh [
	" Update this Document to the latest revision "
	| response |
	response := self information.
	revision := response at: '_rev'.
	object := response couchToObject.
	^response
]

{ #category : #accessing }
CouchDocument >> revision [
	^revision
]

{ #category : #accessing }
CouchDocument >> revision: anObject [
	revision := anObject
]

{ #category : #api }
CouchDocument >> revisions [
	^(self class get: (address copy query: 'revs_info=true')) at: '_revs_info' ifAbsent: [#()]
]

{ #category : #api }
CouchDocument >> save [
	| response |
	response := self class put: address contents: self.
	revision := response at: 'rev'.
	^response
]

{ #category : #'initialize-release' }
CouchDocument >> undefined [
	^ #_undefined
]

{ #category : #api }
CouchDocument >> writeAttachment: nameString contentType: aString bytes: aByteArray [
	| response |
	revision ifNil: [self refresh].
	response := self class writeAttachment: ((address asString, '/' , nameString) asUrl query: 'rev=', revision) contentType: aString bytes: aByteArray.
	revision := response at: 'rev'.
	^response
]
