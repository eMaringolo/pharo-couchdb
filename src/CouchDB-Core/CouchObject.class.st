Class {
	#name : #CouchObject,
	#superclass : #Object,
	#instVars : [
		'url'
	],
	#classVars : [
		'logLevel'
	],
	#category : #'CouchDB-Core-CouchDB-Core'
}

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

{ #category : #'instance creation' }
CouchObject class >> url: addressString [

	^self new setUrl: addressString asZnUrl
]

{ #category : #testing }
CouchObject >> exists [
	[self rawData] on: CouchDBError do: [:sig | ^false].
	^true
]

{ #category : #printing }
CouchObject >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: url asString;
		nextPut: $)
]

{ #category : #api }
CouchObject >> rawData [
	^self class get: url
]

{ #category : #accessing }
CouchObject >> setUrl: aString [
	url := aString
]

{ #category : #accessing }
CouchObject >> url [
	^url
]

{ #category : #accessing }
CouchObject >> url: anObject [
	url := anObject asZnUrl
]
