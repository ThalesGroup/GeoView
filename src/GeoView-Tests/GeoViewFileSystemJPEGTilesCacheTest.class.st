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

	| tile |
	tile := self iconNamed: #pharo.

	cache storeTile: tile level: 1 x: 1 y: 1.
	self assert: (cache tileAtLevel: 1 x: 1 y: 1) bits notNil
]
