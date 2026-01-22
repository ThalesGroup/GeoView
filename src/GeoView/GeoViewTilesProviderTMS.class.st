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

{ #category : #request }
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
