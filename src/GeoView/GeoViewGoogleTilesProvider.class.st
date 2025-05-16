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
GeoViewGoogleTilesProvider >> beAerialType [

	tilesType := 's'
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beRoadNoLabelsType [

	tilesType := 'r'
]

{ #category : #'tiles type' }
GeoViewGoogleTilesProvider >> beRoadType [

	tilesType := 'm'
]

{ #category : #initialization }
GeoViewGoogleTilesProvider >> initialize [

	super initialize.
	self haveCopyrightNote: true.
	self defaultCopyrightNote: self class attributionText.

	self beAerialType
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

	tilesType = 's'
		ifTrue: [ ^ ZnEasy getJpeg: url ]
		ifFalse: [ ^ ZnEasy getPng: url ]
]
