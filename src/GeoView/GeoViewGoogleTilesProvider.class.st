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

{ #category : #initialization }
GeoViewGoogleTilesProvider >> initialize [

	super initialize.
	self haveCopyrightNote: true.
	self defaultCopyrightNote: self class attributionText.

	self beSatelliteType
]

{ #category : #accessing }
GeoViewGoogleTilesProvider >> updateUrl [

	| format |
	
	format := '.png'.
	(tilesType = 's' or:[tilesType = 'y' or:[tilesType = 't' or:[tilesType = 'p']]])
		ifTrue: [ format := '.jpg' ].
		
	self service url: self serverUrl, '?lyrs=', ( tilesType asString ), '&x={x}&y={y}&z={z}&ext=', format
]
