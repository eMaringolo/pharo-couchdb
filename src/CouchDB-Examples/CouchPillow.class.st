Class {
	#name : #CouchPillow,
	#superclass : #Object,
	#instVars : [
		'color',
		'size'
	],
	#category : #'CouchDB-Examples'
}

{ #category : #accessing }
CouchPillow >> color [
	^ color
]

{ #category : #accessing }
CouchPillow >> color: anObject [
	color := anObject
]

{ #category : #'couchdb-mappings' }
CouchPillow >> couchDocumentProperties [ 

	^Dictionary new
		at: 'size' put: #size;
		at: 'color' put: #color;
		yourself
		
]

{ #category : #accessing }
CouchPillow >> size [
	^ size
]

{ #category : #accessing }
CouchPillow >> size: anObject [
	size := anObject
]
