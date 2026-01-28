Class {
	#name : #GeoViewLocalDirectoryTilesProviderTest,
	#superclass : #GeoViewTilesProviderTest,
	#category : #'GeoView-Tests-Map'
}

{ #category : #running }
GeoViewLocalDirectoryTilesProviderTest >> setUp [

	| tile |
	super setUp.

	"use memory directory"
	provider tileDirectory:
		(FileSystem memory / 'GeoViewLocalTilesTest') ensureCreateDirectory.
		
	"create sample tile"
	tile := self iconNamed: #pharo.
	(provider tileDirectory / '1' / '1') ensureCreateDirectory.
	tile writePNGFileNamed: (provider tileDirectory / '1' / '1' / '1.png')
]

{ #category : #running }
GeoViewLocalDirectoryTilesProviderTest >> testLoadNotExistingTileForXY [

	| tile |
	tile := provider loadTileFor: 0 x: 0 y: 0.
	self assert: tile isNil
]

{ #category : #tests }
GeoViewLocalDirectoryTilesProviderTest >> testTileDirectory [

	self
		assert: provider tileDirectory printString
		equals: (FileSystem memory / 'GeoViewLocalTilesTest') printString
]

{ #category : #initialization }
GeoViewLocalDirectoryTilesProviderTest >> tilesProviderClass [

	^ GeoViewLocalDirectoryTilesProvider
]
