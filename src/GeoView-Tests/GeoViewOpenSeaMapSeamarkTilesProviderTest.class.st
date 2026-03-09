"
A GeoViewOpenSeaMapSeamarkTilesProviderTest is a test class for testing the behavior of GeoViewOpenSeaMapSeamarkTilesProvider
"
Class {
	#name : #GeoViewOpenSeaMapSeamarkTilesProviderTest,
	#superclass : #GeoViewTilesProviderTest,
	#category : #'GeoView-Tests-Map'
}

{ #category : #tests }
GeoViewOpenSeaMapSeamarkTilesProviderTest >> testDefaultCopyrightNote [

	self assert: provider defaultCopyrightNote notNil 
]

{ #category : #tests }
GeoViewOpenSeaMapSeamarkTilesProviderTest >> testHaveCopyrightNote [

	self assert: provider haveCopyrightNote 
]

{ #category : #tests }
GeoViewOpenSeaMapSeamarkTilesProviderTest >> testLoadTileForXY [

	| tile |
	super testLoadTileForXY.
	
	tile := provider loadTileFor: 9 x: 1 y: 1.
	self assert: (tile isKindOf: Form)
]

{ #category : #tests }
GeoViewOpenSeaMapSeamarkTilesProviderTest >> testServerUrl [

	self assert: provider serverUrl equals: (provider class primaryTileUrl)
]

{ #category : #initialization }
GeoViewOpenSeaMapSeamarkTilesProviderTest >> tilesProviderClass [

	^ GeoViewOpenSeaMapSeamarkTilesProvider
]
