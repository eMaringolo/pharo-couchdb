Class {
	#name : #BaselineOfCouchDB,
	#superclass : #BaselineOf,
	#category : #BaselineOfCouchDB
}

{ #category : #baselines }
BaselineOfCouchDB >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'NeoJSON'
				with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
			spec
				package: #'CouchDB-Client'
				with: [ spec requires: #('NeoJSON') ].
			spec group: 'default' with: #(#'CouchDB-Client') ]
]
