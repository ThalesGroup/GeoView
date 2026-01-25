Class {
	#name : #GeoViewLocalDirectoryTilesProvider,
	#superclass : #GeoViewTilesProvider,
	#instVars : [
		'tileDirectory',
		'tileExtension'
	],
	#category : #'GeoView-Map'
}

{ #category : #constants }
GeoViewLocalDirectoryTilesProvider class >> defaultDirectory [

	^ FileLocator imageDirectory / 'geoview-local-tiles'
]

{ #category : #'private - cache' }
GeoViewLocalDirectoryTilesProvider >> createCache [
	"Local directory already store tiles on the file system, use a shared memory cache"

	| sharedCache |
	sharedCache := GeoViewSharedMemoryTilesCache new.
	^ sharedCache
]

{ #category : #accessing }
GeoViewLocalDirectoryTilesProvider >> imageType [

	self
		deprecated: 'use tile extension'
		transformWith: '`@receiver imageType' -> '`@receiver tileExtension'.

	^ self tileExtension
]

{ #category : #accessing }
GeoViewLocalDirectoryTilesProvider >> imageType: anObject [

	self deprecated:'private accessor'.
	tileExtension := anObject
]

{ #category : #request }
GeoViewLocalDirectoryTilesProvider >> loadTileFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| filename |
	filename := self
		            tileFilenameFor: aZoomLevel
		            x: anXCoordinate
		            y: anYCoordinate.
	filename ifNil: [ ^ nil ].
	filename parent asFileReference ensureCreateDirectory.
	filename exists ifTrue: [ ^ filename ].
	
	^ nil
]

{ #category : #cache }
GeoViewLocalDirectoryTilesProvider >> sharedCacheKey [

	^ self tileDirectory printString
]

{ #category : #accessing }
GeoViewLocalDirectoryTilesProvider >> supportedExtensions [

	^ #( 'jpg' 'png' 'jpeg' 'JPG' 'PNG' 'JPEG' )
]

{ #category : #accessing }
GeoViewLocalDirectoryTilesProvider >> tileDirectory [

	^ tileDirectory ifNil: [
		  tileDirectory := self class defaultDirectory ]
]

{ #category : #accessing }
GeoViewLocalDirectoryTilesProvider >> tileDirectory: anObject [

	tileDirectory := anObject.
	self changeCache
]

{ #category : #accessing }
GeoViewLocalDirectoryTilesProvider >> tileExtension [

	^ tileExtension
]

{ #category : #request }
GeoViewLocalDirectoryTilesProvider >> tileFilenameFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| filename |
	filename := self tileDirectory asFileReference.
	filename exists ifFalse: [ ^ nil ].

	filename := filename / aZoomLevel asString.
	filename := filename / anXCoordinate asString.
	filename := filename / anYCoordinate asString.

	tileExtension ifNil: [ "trying to find the type of the image"
			tileExtension := self supportedExtensions
				                 detect: [ :ext |
				                 (filename , ext asString) exists ]
				                 ifNone: [ ^ nil ] ].

	filename := filename , tileExtension asString.

	^ filename
]
