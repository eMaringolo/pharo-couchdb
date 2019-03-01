Class {
	#name : #CouchSofa,
	#superclass : #Object,
	#instVars : [
		'weight',
		'pillows'
	],
	#category : #'CouchDB-Examples'
}

{ #category : #examples }
CouchSofa class >> example1 [
	| example |
	example := self new.
	example weight: 100.
	4
		timesRepeat: [ example pillows
				add:
					(CouchPillow new
						size: 40;
						color: Color white;
						yourself) ].
	^example
]

{ #category : #'as yet unclassified' }
CouchSofa >> couchDocumentProperties [ 

	^Dictionary new
		at: 'weight' put: #weight;
		at: 'pillows' put: #pillows;
		yourself
		
]

{ #category : #initialization }
CouchSofa >> initialize [
	
	super initialize.	
	weight := 100.
	pillows := OrderedCollection new.
]

{ #category : #accessing }
CouchSofa >> pillows [
	^ pillows
]

{ #category : #accessing }
CouchSofa >> pillows: anObject [
	pillows := anObject
]

{ #category : #accessing }
CouchSofa >> weight [
	^ weight
]

{ #category : #accessing }
CouchSofa >> weight: anObject [
	weight := anObject
]
