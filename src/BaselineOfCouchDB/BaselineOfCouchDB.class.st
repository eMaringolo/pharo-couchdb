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
				package: #'CouchDB-Core'
				with: [ spec requires: #('NeoJSON') ].
			spec
				package: #'CouchDB-Examples'
				with: [ spec requires: #('CouchDB-Core') ].
			spec group: 'default' with: #(#'CouchDB-Core' 'CouchDB-Examples').
			spec group: 'core' with: #(#'CouchDB-Core').
			 ]
]
