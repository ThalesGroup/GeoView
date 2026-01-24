Class {
	#name : #GeoViewSharedMemoryAndFileSystemTilesCacheTest,
	#superclass : #GeoViewTilesCacheTest,
	#category : #'GeoView-Tests-Map'
}

{ #category : #accessing }
GeoViewSharedMemoryAndFileSystemTilesCacheTest >> cacheClass [

	^ GeoViewSharedMemoryAndFileSystemTilesCache
]

{ #category : #running }
GeoViewSharedMemoryAndFileSystemTilesCacheTest >> setUp [

	super setUp.

	"use memory directory"
	cache fileSystemCache directory:
		(FileSystem memory / 'GeoViewFileSystemTilesCacheTest')
			ensureCreateDirectory
]
