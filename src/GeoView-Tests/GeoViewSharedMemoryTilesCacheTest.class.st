Class {
	#name : #GeoViewSharedMemoryTilesCacheTest,
	#superclass : #GeoViewTilesCacheTest,
	#category : #'GeoView-Tests-Map'
}

{ #category : #accessing }
GeoViewSharedMemoryTilesCacheTest >> cacheClass [

	^ GeoViewSharedMemoryTilesCache
]

{ #category : #tests }
GeoViewSharedMemoryTilesCacheTest >> testStoreTileWhenCacheFull [

	cache maxTilesPerLevel: 2.

	cache storeTile: Form new level: 1 x: 0 y: 0.
	self assert: (cache tilesByLevel at: 1) keys size equals: 1.
	
	cache storeTile: Form new level: 1 x: 1 y: 1.
	self assert: (cache tilesByLevel at: 1) keys size equals: 2.
	
	cache storeTile: Form new level: 1 x: 2 y: 2.
	self assert: (cache tilesByLevel at: 1) keys size equals: 2
]
