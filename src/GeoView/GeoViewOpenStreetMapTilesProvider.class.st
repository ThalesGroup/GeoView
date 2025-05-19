Class {
	#name : #GeoViewOpenStreetMapTilesProvider,
	#superclass : #GeoViewTilesProvider,
	#instVars : [
		'serverUrl'
	],
	#category : #'GeoView-Map'
}

{ #category : #infos }
GeoViewOpenStreetMapTilesProvider class >> attributionText [

	^ '© OpenStreetMap contributors'
]

{ #category : #constants }
GeoViewOpenStreetMapTilesProvider class >> mirror1TileUrl [

	^ 'https://b.tile.openstreetmap.org'
]

{ #category : #constants }
GeoViewOpenStreetMapTilesProvider class >> mirror2TileUrl [

	^ 'https://c.tile.openstreetmap.org'
]

{ #category : #constants }
GeoViewOpenStreetMapTilesProvider class >> primaryTileUrl [

	^ 'https://a.tile.openstreetmap.org'
]

{ #category : #initialization }
GeoViewOpenStreetMapTilesProvider >> initialize [

	super initialize.
	self haveCopyrightNote: true.
	self defaultCopyrightNote: self class attributionText 
]

{ #category : #accessing }
GeoViewOpenStreetMapTilesProvider >> serverUrl [

	^ serverUrl ifNil: [ serverUrl := self class primaryTileUrl ]
]

{ #category : #accessing }
GeoViewOpenStreetMapTilesProvider >> serverUrl: anObject [

	serverUrl := anObject
]

{ #category : #request }
GeoViewOpenStreetMapTilesProvider >> tileFilenameFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	^ self serverUrl , '/' , aZoomLevel printString , '/'
	  , anXCoordinate printString , '/' , anYCoordinate printString
	  , '.png'
]

{ #category : #request }
GeoViewOpenStreetMapTilesProvider >> tileFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	^ ZnEasy getPng:
		  (self
			   tileFilenameFor: aZoomLevel
			   x: anXCoordinate
			   y: anYCoordinate)
]
