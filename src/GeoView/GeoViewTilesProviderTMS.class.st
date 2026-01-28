Class {
	#name : #GeoViewTilesProviderTMS,
	#superclass : #GeoViewTilesProvider,
	#instVars : [
		'service',
		'serverUrl'
	],
	#category : #'GeoView-Map'
}

{ #category : #testing }
GeoViewTilesProviderTMS class >> isAbstract [

	^ self == GeoViewTilesProviderTMS
]

{ #category : #constants }
GeoViewTilesProviderTMS class >> primaryTileUrl [

	self subclassResponsibility
]

{ #category : #'private - cache' }
GeoViewTilesProviderTMS >> createCache [
	"TMS tiles provider are network services, create a cache which store tiles on the file system and also use the memory on running"

	| sharedCache |
	self sharedCacheKey ifNil: [ ^ nil ].
	
	sharedCache := GeoViewSharedMemoryAndFileSystemTilesCache new.
	sharedCache fileSystemCache directory:
		(sharedCache fileSystemCache class defaultCacheRoot
		/ self sharedCacheKey asString).

	^ sharedCache
]

{ #category : #private }
GeoViewTilesProviderTMS >> loadTileFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	^ self service tile: anXCoordinate y: anYCoordinate z: aZoomLevel
]

{ #category : #accessing }
GeoViewTilesProviderTMS >> serverUrl [

	^ serverUrl ifNil: [ serverUrl := self class primaryTileUrl ]
]

{ #category : #accessing }
GeoViewTilesProviderTMS >> serverUrl: anObject [

	serverUrl := anObject.
	self updateUrl
]

{ #category : #accessing }
GeoViewTilesProviderTMS >> service [

	^ service ifNil: [ service := OWSTMS new ]
]

{ #category : #update }
GeoViewTilesProviderTMS >> updateUrl [

	self subclassResponsibility
]
