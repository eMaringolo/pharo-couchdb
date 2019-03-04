"
Database provides an interface to a database running on a CouchDB server.
"
Class {
	#name : #CouchDatabase,
	#superclass : #CouchObject,
	#category : #'CouchDB-Core-CouchDB-Core'
}

{ #category : #'api - database' }
CouchDatabase >> compact [
	^self class post: url, '_compact'
]

{ #category : #'api - documents' }
CouchDatabase >> create: anObject [
	| response |
	response := self class post: url contents: anObject.
	^CouchDocument new
		url: url / (response at: 'id');
		revision: (response at: 'rev');
		object: anObject;
		yourself
]

{ #category : #'api - documents' }
CouchDatabase >> createAll: aCollectionOfObjects [

	| saveAll response documents |
	saveAll := (Dictionary new)
				at: 'docs' put: aCollectionOfObjects;
				yourself.
	response := self class post: url , '_bulk_docs' contents: saveAll.
	documents := OrderedCollection new.
	response with: aCollectionOfObjects
		do: 
			[:dictionary :object |
			| document |
			document := (self document: (dictionary at: 'id')
						revision: (dictionary at: 'rev'))
						object: object;
						yourself.
			documents add: document].	"at: 'new_revs'"
	^documents
]

{ #category : #'api - querying' }
CouchDatabase >> delete [
	^self class delete: self url
]

{ #category : #'api - views' }
CouchDatabase >> design: designName view: viewName [
	^CouchView new
		url: url;
		design: designName;
		name: viewName;
		yourself
]

{ #category : #'api - documents' }
CouchDatabase >> document: id [
	^self document: id revision: nil
]

{ #category : #'api - documents' }
CouchDatabase >> document: id revision: revision [
	^CouchDocument new
		url: url / id;
		revision: revision;
		yourself
]

{ #category : #'api - querying' }
CouchDatabase >> documents [
	^self searchResults: (self class get: url / '_all_docs')
]

{ #category : #'api - querying' }
CouchDatabase >> documentsCount: count [
	^self searchResults: (self class get: url, ('_all_docs?count=', count))
]

{ #category : #'api - querying' }
CouchDatabase >> documentsFrom: start [
	^self searchResults: (self class get: url, ('_all_docs?startkey=', start))
]

{ #category : #'api - querying' }
CouchDatabase >> documentsFrom: start count: count [
	^self searchResults: (self class get: url, ('_all_docs?startkey=', start, '&count=', count))
]

{ #category : #'api - querying' }
CouchDatabase >> documentsFrom: start to: end [
	^self searchResults: (self class get: url, ('_all_docs?startkey=', start, '&endkey=', end))
]

{ #category : #'api - database' }
CouchDatabase >> name [
	^self rawData at: 'db_name'
]

{ #category : #'api - querying' }
CouchDatabase >> reverseDocuments [
	^self searchResults: (self class get: url, '_all_docs?descending=true')
]

{ #category : #'api - querying' }
CouchDatabase >> reverseDocumentsCount: count [
	^self searchResults: (self class get: url, ('_all_docs?descending=true&count=', count))
]

{ #category : #'api - querying' }
CouchDatabase >> reverseDocumentsFrom: start [
	^self searchResults: (self class get: url, ('_all_docs?descending=true&startkey=', start))
]

{ #category : #'api - querying' }
CouchDatabase >> reverseDocumentsFrom: start count: count [
	^self searchResults: (self class get: url, ('_all_docs?descending=true&startkey=', start, '&count=', count))
]

{ #category : #'api - querying' }
CouchDatabase >> reverseDocumentsFrom: start to: end [
	^self searchResults: (self class get: url, ('_all_docs?descending=true&startkey=', start, '&endkey=', end))
]

{ #category : #'api - documents' }
CouchDatabase >> save: aCouchDocument [
	self saveAll: (Array with: aCouchDocument)
]

{ #category : #'api - documents' }
CouchDatabase >> saveAll: aCollectionOfDocuments [

	| saveAll response |
	saveAll := (Dictionary new)
				at: 'docs' put: aCollectionOfDocuments;
				yourself.
	response := self client post: url , '_bulk_docs' contents: saveAll.
	response with: aCollectionOfDocuments
		do: [:dictionary :document | document revision: (dictionary at: 'rev')].	"at: 'new_revs'"
	^response
]

{ #category : #private }
CouchDatabase >> searchResults: results [
	^(results at: 'rows') collect: [:row | self document: (row at: 'id') revision: ((row at: 'value') at: 'rev')]
]
