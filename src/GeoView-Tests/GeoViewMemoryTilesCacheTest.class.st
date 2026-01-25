Class {
	#name : #GeoViewMemoryTilesCacheTest,
	#superclass : #GeoViewTilesCacheTest,
	#category : #'GeoView-Tests-Map'
}

{ #category : #accessing }
GeoViewMemoryTilesCacheTest >> cacheClass [

	^ GeoViewMemoryTilesCache
]

{ #category : #tests }
GeoViewMemoryTilesCacheTest >> testMaxTilesLimitPerLevel [

	self assert: cache maxTilesLimitPerLevel equals: 8192.

	cache maxTilesLimitPerLevel: 1000.
	self assert: cache maxTilesLimitPerLevel equals: 1000
]

{ #category : #tests }
GeoViewMemoryTilesCacheTest >> testNbTiles [

	self assert: cache nbTiles equals: 0.
	
	cache storeTile: Form new level: 1 x: 1 y: 1.
	self assert: cache nbTiles equals: 1.
	
	cache storeTile: Form new level: 1 x: 2 y: 1.
	self assert: cache nbTiles equals: 2.
	
	cache storeTile: Form new level: 1 x: 2 y: 2.
	self assert: cache nbTiles equals: 3.
]

{ #category : #tests }
GeoViewMemoryTilesCacheTest >> testStoreTileWhenCacheFull [

	cache maxTilesLimitPerLevel: 2.

	cache storeTile: Form new level: 1 x: 0 y: 0.
	self assert: (cache tilesByLevel at: 1) keys size equals: 1.
	
	cache storeTile: Form new level: 1 x: 1 y: 1.
	self assert: (cache tilesByLevel at: 1) keys size equals: 2.
	
	cache storeTile: Form new level: 1 x: 2 y: 2.
	self assert: (cache tilesByLevel at: 1) keys size equals: 2
]
