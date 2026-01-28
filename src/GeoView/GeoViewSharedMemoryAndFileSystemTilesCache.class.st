Class {
	#name : #GeoViewSharedMemoryAndFileSystemTilesCache,
	#superclass : #GeoViewTilesCache,
	#instVars : [
		'mutex',
		'memoryCache',
		'fileSystemCache'
	],
	#category : #'GeoView-Map'
}

{ #category : #accessing }
GeoViewSharedMemoryAndFileSystemTilesCache >> fileSystemCache [

	^ fileSystemCache ifNil: [
		  fileSystemCache := GeoViewFileSystemPNGTilesCache new ]
]

{ #category : #accessing }
GeoViewSharedMemoryAndFileSystemTilesCache >> fileSystemCache: anObject [

	fileSystemCache := anObject
]

{ #category : #initialization }
GeoViewSharedMemoryAndFileSystemTilesCache >> initialize [

	super initialize.
	mutex := Monitor new
]

{ #category : #accessing }
GeoViewSharedMemoryAndFileSystemTilesCache >> memoryCache [

	^ memoryCache ifNil: [ memoryCache := GeoViewMemoryTilesCache new ]
]

{ #category : #accessing }
GeoViewSharedMemoryAndFileSystemTilesCache >> memoryCache: anObject [

	memoryCache := anObject
]

{ #category : #accessing }
GeoViewSharedMemoryAndFileSystemTilesCache >> mutex [

	^ mutex
]

{ #category : #accessing }
GeoViewSharedMemoryAndFileSystemTilesCache >> mutex: anObject [

	mutex := anObject
]

{ #category : #'api - cache' }
GeoViewSharedMemoryAndFileSystemTilesCache >> storeTile: tile level: aZoomLevel x: anXCoordinate y: anYCoordinate [

	self mutex critical: [ "first: store file on the file system"
			self fileSystemCache
				storeTile: tile
				level: aZoomLevel
				x: anXCoordinate
				y: anYCoordinate.
			"second: store file on memory"
			self memoryCache
				storeTile: tile
				level: aZoomLevel
				x: anXCoordinate
				y: anYCoordinate ]
]

{ #category : #'api - cache' }
GeoViewSharedMemoryAndFileSystemTilesCache >> tileAtLevel: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| tile |
	self mutex critical: [ "first: search on memory cache"
			tile := self memoryCache
				        tileAtLevel: aZoomLevel
				        x: anXCoordinate
				        y: anYCoordinate.
			tile ifNil: [ "second: search on filesystem cache"
					tile := self fileSystemCache
						        tileAtLevel: aZoomLevel
						        x: anXCoordinate
						        y: anYCoordinate ] ].

	^ tile
]
