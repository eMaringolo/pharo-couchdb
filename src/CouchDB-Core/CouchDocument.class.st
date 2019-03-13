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

	^attachments ifNil: [ attachments := Dictionary new ].
	
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
	response := self class delete: (url copy queryAt: 'rev' put: revision).
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
	^ self url ifNotNil: [ :obj | obj lastPathSegment ]
]

{ #category : #'initialize-release' }
CouchDocument >> initialize [
	super initialize.
	object := self undefined
]

{ #category : #api }
CouchDocument >> initializeAttachmentNamed: filename from: aDictionary [
	| attachment isStub |
	isStub := aDictionary at: 'stub' ifAbsent: [ true ].
	isStub
		ifTrue: [ attachment := CouchAttachmentStub
				name: filename
				mimeType: (aDictionary at: 'content_type')
				in: self.
			attachment
				revision: (aDictionary at: 'revpos');
				length: (aDictionary at: 'length');
				digest: (aDictionary at: 'digest') ]
		ifFalse: [ attachment := CouchAttachment
				name: filename
				mimeType: (aDictionary at: 'content_type')
				in: self.
				attachment contents: (ZnBase64Encoder new decode: (aDictionary at: 'data') ) ].
	attachments at: filename put: attachment
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
	response := self rawData.
	revision := response at: '_rev'.
	attachments := Dictionary new.
	(response includesKey: '_attachments')
		ifTrue: [ 
			 (response at: '_attachments') keysAndValuesDo: [ :key :value |
				self initializeAttachmentNamed: key from: value 
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
	^(self class get: (url copy query: 'revs_info=true')) at: '_revs_info' ifAbsent: [#()]
]

{ #category : #api }
CouchDocument >> save [
	| response |
	response := self class put: url contents: self.
	revision := response at: 'rev'.
	^response
]

{ #category : #attachments }
CouchDocument >> saveAttachment: aCouchAttachment [
	| response |
	revision ifNil: [self refresh].
	response := CouchAttachment save: aCouchAttachment.
	revision := response at: 'rev'.
	^response
]

{ #category : #attachments }
CouchDocument >> saveAttachmentNamed: filename mimeType: mimeType contents: aByteArray [
	| attachment |
	attachment := CouchAttachment
		name: filename
		mimeType: mimeType
		in: self.
	attachment contents: aByteArray.
	^ self saveAttachment: attachment
]

{ #category : #'initialize-release' }
CouchDocument >> undefined [
	^ #_undefined
]
