"
A GeoViewTilesCacheTest is a test class for testing the behavior of GeoViewTilesCache
"
Class {
	#name : #GeoViewTilesCacheTest,
	#superclass : #TestCase,
	#instVars : [
		'cache'
	],
	#category : #'GeoView-Tests-Map'
}

{ #category : #testing }
GeoViewTilesCacheTest class >> isAbstract [ 

	^ self == GeoViewTilesCacheTest
]

{ #category : #accessing }
GeoViewTilesCacheTest >> cacheClass [

	self subclassResponsibility 
]

{ #category : #running }
GeoViewTilesCacheTest >> setUp [

	super setUp.
	cache := self cacheClass new
]

{ #category : #tests }
GeoViewTilesCacheTest >> testStoreTileLevelXY [

	| tile111 tile112 tile122 tile222 |
	tile111 := self iconNamed: #pharo.
	cache storeTile: tile111 level: 1 x: 1 y: 1.
	self assert: (cache tileAtLevel: 1 x: 1 y: 1) bits equals: (tile111 bits).
	
	tile112 := self iconNamed: #pharo.
	cache storeTile: tile112 level: 1 x: 1 y: 2.
	self assert: (cache tileAtLevel: 1 x: 1 y: 2) bits equals: (tile112 bits).
	
	tile122 := self iconNamed: #pharo.
	cache storeTile: tile122 level: 1 x: 2 y: 2.
	self assert: (cache tileAtLevel: 1 x: 2 y: 2) bits equals: (tile122 bits).
	
	tile222 := self iconNamed: #pharo.
	cache storeTile: tile222 level: 2 x: 2 y: 2.
	self assert: (cache tileAtLevel: 2 x: 2 y: 2) bits equals: (tile222 bits).
]

{ #category : #tests }
GeoViewTilesCacheTest >> testTileAtLevelXY [

	self assert: (cache tileAtLevel: 0 x: 0 y: 0) isNil.

	self assert: (cache tileAtLevel: 1 x: 1 y: 1) isNil.
	
	self assert: (cache tileAtLevel: 1 x: 1 y: 2) isNil.
	
	self assert: (cache tileAtLevel: 1 x: 2 y: 2) isNil.
	
	self assert: (cache tileAtLevel: 2 x: 2 y: 2) isNil.
]
