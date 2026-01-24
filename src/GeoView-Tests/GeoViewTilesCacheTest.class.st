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

	| tile |
	tile := self iconNamed: #pharo.

	cache storeTile: tile level: 1 x: 1 y: 1.
	self assert: (cache tileAtLevel: 1 x: 1 y: 1) bits equals: (tile bits)
]

{ #category : #tests }
GeoViewTilesCacheTest >> testTileAtLevelXY [

	self assert: (cache tileAtLevel: 1 x: 1 y: 1) isNil
]
