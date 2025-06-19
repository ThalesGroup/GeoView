Class {
	#name : #GeoViewTilesProviderTMS,
	#superclass : #GeoViewTilesProvider,
	#instVars : [
		'service',
		'serverUrl'
	],
	#category : #'GeoView-Map'
}

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

{ #category : #request }
GeoViewTilesProviderTMS >> tileFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	^ self service tile: anXCoordinate y: anYCoordinate z: aZoomLevel
]

{ #category : #update }
GeoViewTilesProviderTMS >> updateUrl [

	self subclassResponsibility
]
