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
	^self class put: address / databaseName
]

{ #category : #api }
CouchInterface >> database: databaseName [

	^(CouchDatabase new)
		address: self address / databaseName;
		yourself
]

{ #category : #api }
CouchInterface >> databases [
	^(self class get: self address / '_all_dbs') collect: [:each | self database: each]
]

{ #category : #api }
CouchInterface >> delete: databaseName [
	^self class delete: self address / databaseName
]

{ #category : #api }
CouchInterface >> deleteDatabase: databaseName [

	^self class delete: self address, '/', databaseName
]

{ #category : #'initialize-release' }
CouchInterface >> initialize [
	super initialize.
	address := 'http://127.0.0.1:5984/' asZnUrl
]
