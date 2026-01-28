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
	provider := self tilesProviderClass new
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
GeoViewTilesProviderTest >> testIsCachingTiles [

	self assert: provider isCachingTiles.
	
	provider isCachingTiles: false.
	self deny: provider isCachingTiles.
]

{ #category : #tests }
GeoViewTilesProviderTest >> testLoadTileForXY [

	| tile |
	tile := provider loadTileFor: 1 x: 1 y: 1.
	self assert: tile notNil
]

{ #category : #tests }
GeoViewTilesProviderTest >> testLoadTileForXYWithoutCache [

	| tile |
	provider isCachingTiles: false.

	tile := provider loadTileFor: 1 x: 1 y: 1.
	self assert: tile notNil
]

{ #category : #tests }
GeoViewTilesProviderTest >> testSharedCacheFor [

	| cache |
	cache := self tilesProviderClass sharedCacheFor: provider.
	self assert: cache notNil.
]

{ #category : #tests }
GeoViewTilesProviderTest >> testSharedCacheKey [

	self assert: provider sharedCacheKey notNil
]

{ #category : #initialization }
GeoViewTilesProviderTest >> tilesProviderClass [

	self subclassResponsibility 
]
