Class {
	#name : #CouchObject,
	#superclass : #Object,
	#instVars : [
		'address'
	],
	#classVars : [
		'logLevel'
	],
	#category : #'CouchDB-Core-CouchDB-Core'
}

{ #category : #'instance creation' }
CouchObject class >> address: addressString [

	^self new setAddress: addressString asZnUrl
]

{ #category : #private }
CouchObject class >> delete: uri [
	^self request: [:client | client delete: uri]
]

{ #category : #private }
CouchObject class >> get: uriString [
	^ self
		request: [ :client | client get: uriString ]
]

{ #category : #logging }
CouchObject class >> logLevel [
	^ logLevel ifNil: [ logLevel := 0 ]
]

{ #category : #logging }
CouchObject class >> logLevel: anInteger [

	logLevel := anInteger
]

{ #category : #logging }
CouchObject class >> loggingOff [

	self logLevel: 0
]

{ #category : #logging }
CouchObject class >> loggingOn [

	self logLevel: 2
]

{ #category : #'instance creation' }
CouchObject class >> new [
	^super new initialize
]

{ #category : #private }
CouchObject class >> post: uriString [
	^ self
		request: [ :client | 
			client
				url: uriString;
				post ]
]

{ #category : #private }
CouchObject class >> post: uri contents: anObject [
	^ self
		request: [ :client | 
			client
				url: uri;
				contents: anObject couchJson;
				contentType: ZnMimeType applicationJson;
				post ]
]

{ #category : #private }
CouchObject class >> put: uri [
	^ self
		request: [ :client | 
			client
				url: uri;
				put ]
]

{ #category : #private }
CouchObject class >> put: uri contents: anObject [
	^ self
		request: [ :client | 
			client
				url: uri;
				contentWriter: [ :data | ZnEntity json: data couchJson ];
				contents: anObject;
				put ]
]

{ #category : #private }
CouchObject class >> request: aBlock [
	| client response |
	client := ZnClient new
		beOneShot;
		accept: ZnMimeType applicationJson;
		contentReader: [ :entity | NeoJSONReader fromString: entity readStream ].
	self logLevel > 0
		ifTrue: [ client
				logLevel: self logLevel;
				logToTranscript ].
	^ [ response := aBlock value: client.
	(response isArray not and: [ response includesKey: 'error' ])
		ifTrue: [ CouchDBError new signal: (response at: 'reason') ]
		ifFalse: [ response ] ]
		on: ZnHttpUnsuccessful
		do: [ :ex | CouchDBError new signal: ex description ]
]

{ #category : #accessing }
CouchObject >> address [
	^address
]

{ #category : #accessing }
CouchObject >> address: anObject [
	address := anObject asZnUrl
]

{ #category : #testing }
CouchObject >> exists [
	[self information] on: CouchDBError do: [:sig | ^false].
	^true
]

{ #category : #api }
CouchObject >> information [
	^self class get: address
]

{ #category : #printing }
CouchObject >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: address asString;
		nextPut: $)
]

{ #category : #accessing }
CouchObject >> setAddress: aString [
	address := aString
]
