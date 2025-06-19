"
A GeoViewOpenStreetMapTilesProviderTest is a test class for testing the behavior of GeoViewOpenStreetMapTilesProvider
"
Class {
	#name : #GeoViewOpenStreetMapTilesProviderTest,
	#superclass : #TestCase,
	#instVars : [
		'provider'
	],
	#category : #'GeoView-Tests-Map'
}

{ #category : #running }
GeoViewOpenStreetMapTilesProviderTest >> setUp [

	super setUp.

	provider := GeoViewOpenStreetMapTilesProvider new
]

{ #category : #tests }
GeoViewOpenStreetMapTilesProviderTest >> testHaveCopyrightNote [

	self assert: provider haveCopyrightNote 
]

{ #category : #tests }
GeoViewOpenStreetMapTilesProviderTest >> testInitialize [

	self assert: provider notNil
]

{ #category : #tests }
GeoViewOpenStreetMapTilesProviderTest >> testServerUrl [

	self assert: provider serverUrl equals: (provider class primaryTileUrl)
]
