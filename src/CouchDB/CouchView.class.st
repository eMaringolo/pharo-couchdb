"
View provides an interface to a view on a database running on a CouchDB server.


"
Class {
	#name : #CouchView,
	#superclass : #CouchObject,
	#instVars : [
		'design',
		'name'
	],
	#category : #CouchDB
}

{ #category : #accessing }
CouchView >> design [
	^design
]

{ #category : #accessing }
CouchView >> design: anObject [
	design := anObject
]

{ #category : #'api - querying' }
CouchView >> documents [

	^self searchResults: (self client
				get: self address , '_design/' , (design , '/') , '_view/' , name)
]

{ #category : #accessing }
CouchView >> name [
	^name
]

{ #category : #accessing }
CouchView >> name: anObject [
	name := anObject
]

{ #category : #private }
CouchView >> searchResults: results [
	^(results at: 'rows') collect: [:row |
		CouchObjectDocument new
			address: address, (row at: 'id');
			object: (row at: 'value') couchToObject;
			yourself]
]
