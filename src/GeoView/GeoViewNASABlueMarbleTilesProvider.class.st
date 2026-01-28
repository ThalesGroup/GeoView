"
More informations about the NASA Blue Marble datas: https://science.nasa.gov/earth/earth-observatory/collections/blue-marble/
API reference: https://nasa-gibs.github.io/gibs-api-docs/
"
Class {
	#name : #GeoViewNASABlueMarbleTilesProvider,
	#superclass : #GeoViewTilesProviderTMS,
	#category : #'GeoView-Map'
}

{ #category : #infos }
GeoViewNASABlueMarbleTilesProvider class >> attributionText [

	^ 'Blue Marble © NASA'
]

{ #category : #constants }
GeoViewNASABlueMarbleTilesProvider class >> primaryTileUrl [

	^ 'https://gibs.earthdata.nasa.gov/wmts/epsg3857/best/BlueMarble_ShadedRelief_Bathymetry/default/2024-01-01/GoogleMapsCompatible_Level8'
]

{ #category : #'private - cache' }
GeoViewNASABlueMarbleTilesProvider >> createCache [

	| sharedCache fileSystemCache |
	sharedCache := super createCache ifNil: [ ^ nil ].

	fileSystemCache := GeoViewFileSystemJPEGTilesCache new.
	fileSystemCache directory:
		fileSystemCache class defaultCacheRoot
		/ self sharedCacheKey asString.

	sharedCache fileSystemCache: fileSystemCache.

	^ sharedCache
]

{ #category : #initialization }
GeoViewNASABlueMarbleTilesProvider >> initialize [

	super initialize.

	self haveCopyrightNote: true.
	self defaultCopyrightNote: self class attributionText.
	self updateUrl
]

{ #category : #cache }
GeoViewNASABlueMarbleTilesProvider >> sharedCacheKey [

	^ 'NASA Blue Marble'
]

{ #category : #update }
GeoViewNASABlueMarbleTilesProvider >> updateUrl [

	self service url: self serverUrl, '/{z}/{y}/{x}.jpg'
]
