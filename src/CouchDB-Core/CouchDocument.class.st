Class {
	#name : #CouchDocument,
	#superclass : #CouchObject,
	#instVars : [
		'revision',
		'object',
		'attachments'
	],
	#category : #'CouchDB-Core-CouchDB-Core'
}

{ #category : #'instance creation' }
CouchDocument class >> with: anObject [
	^ self new
		object: anObject;
		yourself
]

{ #category : #accessing }
CouchDocument >> attachments [

	^attachments ifNil: [ attachments := OrderedCollection new ].
	
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

{ #category : #attachments }
CouchDocument >> deleteAttachement: aCouchAttachment [
	| response |
	revision ifNil: [self refresh].
	response := CouchAttachment delete: aCouchAttachment .
	revision := response at: '_rev'.
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
	attachments := Dictionary new.
	(response includesKey: '_attachments')
		ifTrue: [ 
			 (response at: '_attachments') keysAndValuesDo: [ :key :value |
				attachments at: key put: value 
				 ]
			].
					
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

{ #category : #attachments }
CouchDocument >> saveAttachment: aCouchAttachment [
	| response |
	revision ifNil: [self refresh].
	response := CouchAttachment save: aCouchAttachment.
	1 halt.
	revision := response at: '_rev'.
	^response
]

{ #category : #'initialize-release' }
CouchDocument >> undefined [
	^ #_undefined
]
