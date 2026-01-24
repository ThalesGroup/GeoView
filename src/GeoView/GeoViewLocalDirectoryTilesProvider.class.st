Class {
	#name : #GeoViewLocalDirectoryTilesProvider,
	#superclass : #GeoViewTilesProvider,
	#instVars : [
		'tileDirectory',
		'imageType'
	],
	#category : #'GeoView-Map'
}

{ #category : #constants }
GeoViewLocalDirectoryTilesProvider class >> defaultDirectory [

	^ FileLocator imageDirectory / 'map' / 'r'
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

	^ imageType
]

{ #category : #accessing }
GeoViewLocalDirectoryTilesProvider >> imageType: anObject [

	imageType := anObject
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
GeoViewLocalDirectoryTilesProvider >> tileDirectory [

	^ tileDirectory ifNil: [
		  tileDirectory := self class defaultDirectory ]
]

{ #category : #accessing }
GeoViewLocalDirectoryTilesProvider >> tileDirectory: anObject [

	tileDirectory := anObject.
	self changeCache
]

{ #category : #request }
GeoViewLocalDirectoryTilesProvider >> tileFilenameFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| filename types |
	filename := self tileDirectory asFileReference.
	filename exists ifFalse: [ ^ nil ].

	filename := filename / aZoomLevel asString.
	filename := filename / anXCoordinate asString.
	filename := filename / anYCoordinate asString.

	imageType ifNil:[
		"trying to find the type of the image"	
		types := #( 'jpg' 'png' ).
		imageType := types detect:[ :e | (filename , (e asString)) exists ] ifNone:[ ^ nil ].
	].
	
	filename := filename , imageType asString.

	^ filename
]
