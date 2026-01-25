Class {
	#name : #GeoViewFileSystemJPEGTilesCacheTest,
	#superclass : #GeoViewFileSystemTilesCacheTest,
	#category : #'GeoView-Tests-Map'
}

{ #category : #accessing }
GeoViewFileSystemJPEGTilesCacheTest >> cacheClass [

	^ GeoViewFileSystemJPEGTilesCache
]

{ #category : #tests }
GeoViewFileSystemJPEGTilesCacheTest >> testStoreTileLevelXY [
	"Need to redefine this test because of JPEG destroy the bits content (loss content)"

	| tile111 tile112 tile122 tile222 |
	tile111 := self iconNamed: #pharo.
	cache storeTile: tile111 level: 1 x: 1 y: 1.
	self assert: (cache tileAtLevel: 1 x: 1 y: 1) bits notNil.
	
	tile112 := self iconNamed: #pharo.
	cache storeTile: tile112 level: 1 x: 1 y: 2.
	self assert: (cache tileAtLevel: 1 x: 1 y: 2) bits notNil.
	
	tile122 := self iconNamed: #pharo.
	cache storeTile: tile122 level: 1 x: 2 y: 2.
	self assert: (cache tileAtLevel: 1 x: 2 y: 2) bits notNil.
	
	tile222 := self iconNamed: #pharo.
	cache storeTile: tile222 level: 2 x: 2 y: 2.
	self assert: (cache tileAtLevel: 2 x: 2 y: 2) bits notNil.
]
