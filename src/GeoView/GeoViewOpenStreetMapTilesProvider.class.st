Class {
	#name : #GeoViewOpenStreetMapTilesProvider,
	#superclass : #GeoViewTilesProvider,
	#instVars : [
		'serverUrl',
		'znClient'
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
	self initializeZnClient.
	self haveCopyrightNote: true. 
	self defaultCopyrightNote: self class attributionText
]

{ #category : #initialization }
GeoViewOpenStreetMapTilesProvider >> initializeZnClient [

	znClient := ZnClient new.
	znClient
		loggingOff;
		accept: ZnMimeType imagePng;
		enforceHttpSuccess: true;
		enforceAcceptContentType: true;
		beOneShot
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

	| url contents |
	url := self
		       tileFilenameFor: aZoomLevel
		       x: anXCoordinate
		       y: anYCoordinate.
	url ifNil: [ ^ nil ].

	self znClient get: url.
	contents := self znClient contents.
	contents ifNil: [ ^ nil ].

	^ ImageReadWriter formFromStream: contents readStream
]

{ #category : #initialization }
GeoViewOpenStreetMapTilesProvider >> znClient [
	
	^ znClient
]
