"
Interface provides a top-level interface in to the CouchDB running server.

"
Class {
	#name : #CouchInterface,
	#superclass : #CouchObject,
	#classVars : [
		'Default'
	],
	#category : #'CouchDB-Core-CouchDB-Core'
}

{ #category : #api }
CouchInterface >> create: databaseName [
	self class put: url / databaseName.
	^CouchDatabase url: url / databaseName
]

{ #category : #api }
CouchInterface >> database: databaseName [

	^(CouchDatabase new)
		url: self url / databaseName;
		yourself
]

{ #category : #api }
CouchInterface >> databases [
	^(self class get: self url / '_all_dbs') collect: [:each | self database: each]
]

{ #category : #api }
CouchInterface >> delete: databaseName [
	^self class delete: self url / databaseName
]

{ #category : #api }
CouchInterface >> deleteDatabase: databaseName [

	^self class delete: self url, '/', databaseName
]

{ #category : #'initialize-release' }
CouchInterface >> initialize [
	super initialize.
	url := 'http://127.0.0.1:5984/' asZnUrl
]
