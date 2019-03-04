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

{ #category : #accessing }
CouchAttachmentStub >> digest [
	^ digest
]

{ #category : #accessing }
CouchAttachmentStub >> digest: anObject [
	digest := anObject
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
