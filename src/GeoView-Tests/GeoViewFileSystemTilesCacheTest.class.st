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
