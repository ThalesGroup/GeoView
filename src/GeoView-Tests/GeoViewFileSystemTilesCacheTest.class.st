Class {
	#name : #GeoViewFileSystemTilesCacheTest,
	#superclass : #GeoViewTilesCacheTest,
	#category : #'GeoView-Tests-Map'
}

{ #category : #testing }
GeoViewFileSystemTilesCacheTest class >> isAbstract [ 

	^ self == GeoViewFileSystemTilesCacheTest
]

{ #category : #running }
GeoViewFileSystemTilesCacheTest >> setUp [

	super setUp.

	"use memory directory"
	cache directory:
		(FileSystem memory / 'GeoViewFileSystemTilesCacheTest')
			ensureCreateDirectory
]

{ #category : #tests }
GeoViewFileSystemTilesCacheTest >> testDirectory [

	self
		assert: cache directory printString
		equals:
		(FileSystem memory / 'GeoViewFileSystemTilesCacheTest') printString.

	cache directory:
		(FileSystem memory / 'GeoViewFileSystemTilesCacheTest2')
			ensureCreateDirectory.

	self
		assert: cache directory printString
		equals:
		(FileSystem memory / 'GeoViewFileSystemTilesCacheTest2') printString
]
