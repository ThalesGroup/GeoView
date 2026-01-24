Class {
	#name : #GeoViewGoogleTilesProvider,
	#superclass : #GeoViewTilesProviderTMS,
	#instVars : [
		'tilesType'
	],
	#category : #'GeoView-Map'
}

{ #category : #infos }
GeoViewGoogleTilesProvider class >> attributionText [

	^ '© Google Maps'
]

{ #category : #constants }
GeoViewGoogleTilesProvider class >> mirror1TileUrl [

	^ 'https://mt2.google.com/vt'
]

{ #category : #constants }
GeoViewGoogleTilesProvider class >> mirror2TileUrl [

	^ 'https://mt3.google.com/vt'
]

{ #category : #constants }
GeoViewGoogleTilesProvider class >> primaryTileUrl [

	^ 'https://mt1.google.com/vt'
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beHybridType [

	tilesType := 'y'.
	self updateUrl
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beRoadmapType [

	tilesType := 'm'.
	self updateUrl
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beRoadsOnlyType [

	tilesType := 'h'.
	self updateUrl
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beSatelliteType [

	tilesType := 's'.
	self updateUrl
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beTerrainOnlyType [

	tilesType := 't'.
	self updateUrl
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beTerrainType [

	tilesType := 'p'.
	self updateUrl
]

{ #category : #'private - cache' }
GeoViewGoogleTilesProvider >> createCache [

	| sharedCache |
	sharedCache := GeoViewSharedMemoryAndFileSystemTilesCache new.

	self tileImageType = #jpg ifTrue: [
		sharedCache fileSystemCache: GeoViewFileSystemJPEGTilesCache new ].

	sharedCache fileSystemCache directory:
		sharedCache fileSystemCache class defaultCacheRoot
		/ self sharedCacheKey asString.

	^ sharedCache
]

{ #category : #initialization }
GeoViewGoogleTilesProvider >> initialize [

	super initialize.

	self beSatelliteType.

	self haveCopyrightNote: true.
	self defaultCopyrightNote: self class attributionText
]

{ #category : #cache }
GeoViewGoogleTilesProvider >> sharedCacheKey [

	tilesType ifNil: [ ^ nil ].
	^ 'Google-' , tilesType asString
]

{ #category : #accessing }
GeoViewGoogleTilesProvider >> tileImageType [

	| type |
	type := #png.
	(#( 's' 'y' 't' 'p' ) includes: tilesType) ifTrue: [ type := #jpg ].

	^ type
]

{ #category : #update }
GeoViewGoogleTilesProvider >> updateUrl [

	| extension |
	extension := self tileImageType asString.

	self service url: self serverUrl , '?lyrs=' , tilesType asString
		, '&x={x}&y={y}&z={z}&ext=' , '.' , extension.

	self changeCache
]
