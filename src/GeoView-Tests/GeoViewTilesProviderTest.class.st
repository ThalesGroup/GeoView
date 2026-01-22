"
A GeoViewTilesProviderTest is a test class for testing the behavior of GeoViewTilesProvider
"
Class {
	#name : #GeoViewTilesProviderTest,
	#superclass : #TestCase,
	#instVars : [
		'provider'
	],
	#category : #'GeoView-Tests-Map'
}

{ #category : #testing }
GeoViewTilesProviderTest class >> isAbstract [ 

	^ self == GeoViewTilesProviderTest
]

{ #category : #running }
GeoViewTilesProviderTest >> setUp [

	super setUp.
	provider := self tilesProvider
]

{ #category : #running }
GeoViewTilesProviderTest >> tearDown [

	provider class cleanCaches.

	super tearDown
]

{ #category : #tests }
GeoViewTilesProviderTest >> testCache [

	self assert: provider cache notNil
]

{ #category : #tests }
GeoViewTilesProviderTest >> testDefaultCopyrightNote [

	self assert: provider defaultCopyrightNote isNil 
]

{ #category : #tests }
GeoViewTilesProviderTest >> testHaveCopyrightNote [

	self deny: provider haveCopyrightNote 
]

{ #category : #tests }
GeoViewTilesProviderTest >> testLoadTileForXY [

	| tile |
	tile := provider loadTileFor: 1 x: 1 y: 1.
	self assert: tile notNil.
]

{ #category : #tests }
GeoViewTilesProviderTest >> testSharedCacheKey [

	self assert: provider sharedCacheKey notNil
]

{ #category : #initialization }
GeoViewTilesProviderTest >> tilesProvider [

	self subclassResponsibility 
]
