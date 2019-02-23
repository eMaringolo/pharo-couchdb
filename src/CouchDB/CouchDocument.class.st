"
Document provides an interface to a document in a database running on a CouchDB server.

Instance Variables:
	object	<Object>	the data/object for this document
	revision	<String>		the revision id for this document


"
Class {
	#name : #CouchDocument,
	#superclass : #CouchObject,
	#instVars : [
		'object',
		'revision'
	],
	#classVars : [
		'Undefined'
	],
	#category : #CouchDB
}

{ #category : #'instance creation' }
CouchDocument class >> neoJsonMapping: mapper [
	mapper
		for: self
		do: [ :mapping | 
			mapping mapAccessor: #id to: '_id'.
			mapping mapInstVar: #revision to: '_rev'.
			mapping
				mapProperty: '+class'
				getter: [ :receiver | receiver object class name asString ]
				setter: [ :receiver :value | value asSymbol asClass ].
			mapping mapInstVar: #object to: 'object' ]
]

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

{ #category : #api }
CouchDocument >> delete [
	| response |
	revision ifNil: [self refresh].
	response := self class delete: (address copy query: 'rev=', revision).
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

{ #category : #converting }
CouchDocument >> jsonWriteOn: aStream [
	aStream nextPutAll: '{'.
	aStream nextPutAll: '"_id":'.
	self id jsonWriteOn: aStream.
	self revision ifNotNil:
		[aStream nextPutAll: ',"_rev":'.
		self revision jsonWriteOn: aStream].
	object jsonKeysAndValuesDo: [:key :value |
		aStream nextPutAll: ','.
		key jsonWriteOn: aStream.
		aStream nextPutAll: ':'.
		value jsonWriteOn: aStream].
	aStream nextPutAll: '}'
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
	((response includesKey: '+class')
		and: [ response includesKey: 'object' ])
		ifTrue: [ | class |
			class := (response at: '+class') asSymbol asClass.
			({Array. Dictionary. String. Integer} includes: class)
				ifTrue: [ object :=  NeoJSONReader
						fromString: (NeoJSONWriter toString: response object) ]
				ifFalse: [ object := NeoJSONReader
						fromString: (NeoJSONWriter toString: response object)
						as: class ] ]
		ifFalse: [ object := response ].
	^ response
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
	response := self class writeAttachment: ((address asString, '/' , nameString) asURI query: 'rev=', revision) contentType: aString bytes: aByteArray.
	revision := response at: 'rev'.
	^response
]
