Class {
	#name : #CouchAttachmentStub,
	#superclass : #CouchAttachment,
	#instVars : [
		'length',
		'digest',
		'revision'
	],
	#category : #'CouchDB-Core-CouchDB-Core'
}

{ #category : #private }
CouchAttachmentStub class >> downloadContentsAt: url to: path [
	^ [ ZnClient new
		beOneShot;
		url: url;
		downloadEntityTo: path;
		get ]
		on: ZnHttpUnsuccessful
		do: [ :ex | CouchDBError new signal: ex description ]
]

{ #category : #private }
CouchAttachmentStub class >> get: url [
	^ [ ZnClient new
		beOneShot;
		url: url;
		get ]
		on: ZnHttpUnsuccessful
		do: [ :ex | CouchDBError new signal: ex description ]
]

{ #category : #accessing }
CouchAttachmentStub >> digest [
	^ digest
]

{ #category : #accessing }
CouchAttachmentStub >> digest: anObject [
	digest := anObject
]

{ #category : #accessing }
CouchAttachmentStub >> download [ 
	
	^(CouchAttachment name: self name mimeType: self mimeType in: self document)
		contents: (self class get: self url);
		yourself

	
]

{ #category : #accessing }
CouchAttachmentStub >> downloadContentsTo: path [
	^ self class downloadContentsAt: self url to: path
]

{ #category : #testing }
CouchAttachmentStub >> isStub [

	^true
]

{ #category : #accessing }
CouchAttachmentStub >> length [
	^ length
]

{ #category : #accessing }
CouchAttachmentStub >> length: anObject [
	length := anObject
]

{ #category : #accessing }
CouchAttachmentStub >> revision [
	^ revision
]

{ #category : #accessing }
CouchAttachmentStub >> revision: anObject [
	revision := anObject
]
