Class {
	#name : #CouchAttachment,
	#superclass : #CouchObject,
	#instVars : [
		'document',
		'name',
		'mimeType',
		'contents'
	],
	#category : #'CouchDB-Core-CouchDB-Core'
}

{ #category : #'instance creation' }
CouchAttachment class >> delete: aCouchAttachment [

	self request: [ :zn |
		zn url: aCouchAttachment url.
		zn headerAt: 'If-Match' put: aCouchAttachment  revision.
		zn delete	
	 ]
]

{ #category : #'instance creation' }
CouchAttachment class >> name: aString mimeType: mimeType in: aCouchDocument [
	"Creates a new instance of receiver belonging to aCouchDocument,
	with name aString and a mimeType."
	
	^self new 
		setName: aString
		mimeType: mimeType asZnMimeType 
		document: aCouchDocument

]

{ #category : #'instance creation' }
CouchAttachment class >> save: aCouchAttachment [

	self request: [ :zn |
		zn url: aCouchAttachment url.
		zn headerAt: 'If-Match' put: aCouchAttachment document revision.
		zn beBinary.
		zn contents: aCouchAttachment contents.
		zn contentType: aCouchAttachment mimeType.
		zn put	
	 ]
]

{ #category : #accessing }
CouchAttachment >> contents [
	^ contents
]

{ #category : #accessing }
CouchAttachment >> contents: aByteArray [
	contents := aByteArray
]

{ #category : #accessing }
CouchAttachment >> document [
	^ document
]

{ #category : #initialization }
CouchAttachment >> isStub [

	^false
]

{ #category : #accessing }
CouchAttachment >> mimeType [
	^ mimeType
]

{ #category : #accessing }
CouchAttachment >> name [
	^ name
]

{ #category : #initialization }
CouchAttachment >> setName: aString mimeType: aZnMimeType document: aCouchDocument [

	name := aString.
	mimeType := aZnMimeType.
	document := aCouchDocument.
	self url.
]

{ #category : #accessing }
CouchAttachment >> url [

	^url ifNil: [ url := self document url / self name ]
]
