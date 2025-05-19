Class {
	#name : #GeoViewGoogleTilesProvider,
	#superclass : #GeoViewTilesProvider,
	#instVars : [
		'serverUrl',
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

	tilesType := 'y'
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beRoadmapType [

	tilesType := 'm'
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beRoadsOnlyType [

	tilesType := 'h'
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beSatelliteType [

	tilesType := 's'
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beTerrainOnlyType [

	tilesType := 't'
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beTerrainType [

	tilesType := 'p'
]

{ #category : #initialization }
GeoViewGoogleTilesProvider >> initialize [

	super initialize.
	self haveCopyrightNote: true.
	self defaultCopyrightNote: self class attributionText.

	self beSatelliteType
]

{ #category : #accessing }
GeoViewGoogleTilesProvider >> serverUrl [

	^ serverUrl ifNil: [ serverUrl := self class primaryTileUrl ]
]

{ #category : #accessing }
GeoViewGoogleTilesProvider >> serverUrl: anObject [

	serverUrl := anObject
]

{ #category : #request }
GeoViewGoogleTilesProvider >> tileFilenameFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	^ self serverUrl , '/lyrs=' , ( tilesType asString ) , '&x=' , anXCoordinate printString , '&y='
	  , anYCoordinate printString , '&z=' , aZoomLevel printString
]

{ #category : #request }
GeoViewGoogleTilesProvider >> tileFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| url |
	url := self
		       tileFilenameFor: aZoomLevel
		       x: anXCoordinate
		       y: anYCoordinate.

	(tilesType = 's' or:[tilesType = 'y' or:[tilesType = 't' or:[tilesType = 'p']]])
		ifTrue: [ ^ ZnEasy getJpeg: url ]
		ifFalse: [ ^ ZnEasy getPng: url ]
]
