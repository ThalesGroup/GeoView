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

{ #category : #initialization }
GeoViewNASABlueMarbleTilesProvider >> initialize [

	super initialize.
	self haveCopyrightNote: true.
	self defaultCopyrightNote: self class attributionText.
	self updateUrl
]

{ #category : #update }
GeoViewNASABlueMarbleTilesProvider >> updateUrl [

	self service url: self serverUrl, '/{z}/{y}/{x}.jpg'
]
