Class {
	#name : #GeoViewOpenStreetMapTilesProvider,
	#superclass : #GeoViewTilesProviderTMS,
	#instVars : [
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
	self haveCopyrightNote: true. 
	self defaultCopyrightNote: self class attributionText.
	self updateUrl
]

{ #category : #update }
GeoViewOpenStreetMapTilesProvider >> updateUrl [

	self service url: self serverUrl, '/{z}/{x}/{y}.png'
]
