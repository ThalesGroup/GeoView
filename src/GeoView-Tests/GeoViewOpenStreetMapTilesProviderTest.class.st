"
A GeoViewOpenStreetMapTilesProviderTest is a test class for testing the behavior of GeoViewOpenStreetMapTilesProvider
"
Class {
	#name : #GeoViewOpenStreetMapTilesProviderTest,
	#superclass : #GeoViewTilesProviderTest,
	#category : #'GeoView-Tests-Map'
}

{ #category : #tests }
GeoViewOpenStreetMapTilesProviderTest >> testDefaultCopyrightNote [

	self assert: provider defaultCopyrightNote notNil 
]

{ #category : #tests }
GeoViewOpenStreetMapTilesProviderTest >> testHaveCopyrightNote [

	self assert: provider haveCopyrightNote 
]

{ #category : #tests }
GeoViewOpenStreetMapTilesProviderTest >> testServerUrl [

	self assert: provider serverUrl equals: (provider class primaryTileUrl)
]

{ #category : #initialization }
GeoViewOpenStreetMapTilesProviderTest >> tilesProvider [

	^ GeoViewOpenStreetMapTilesProvider new
]
