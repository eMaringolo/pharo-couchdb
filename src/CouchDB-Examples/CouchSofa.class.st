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
	1 to: 4 do: [ :index |
		example addPillow:
					(CouchPillow new
						size: 40;
						color: (#(#white #black) at: (index \\ 2)+1);
						yourself) ].
	^example
]

{ #category : #examples }
CouchSofa class >> example2 [
	| example |
	example := self new.
	example weight: 200.
	1 to: 4 do: [ :index |
		example addPillow:
					(CouchPillow new
						size: 40;
						color: (#(#blue #orange) at: (index \\ 2)+1);
						yourself) ].
	^example
]

{ #category : #accessing }
CouchSofa >> addPillow: aCouchPillow [
	^self pillows add: aCouchPillow 
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
