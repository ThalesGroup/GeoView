Class {
	#name : #GeoArcBandProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-Business - GeoObjects'
}

{ #category : #dShape }
GeoArcBandProcessData >> createDShapeInstance [

	^ SmockDArcBand new
]

{ #category : #processing }
GeoArcBandProcessData >> processCreatedData: aKey incoming: aGeoArcBand with: aDArcBand context: aContext [
	| dArcBand |
	
	dArcBand := aDArcBand.
	dArcBand := super processCreatedData: aKey incoming: aGeoArcBand with: dArcBand context: aContext.

	aGeoArcBand radiusInMeters1 < aGeoArcBand radiusInMeters2 
		ifTrue: [ dArcBand radiusMin: aGeoArcBand radiusInMeters1. dArcBand radiusMax: aGeoArcBand radiusInMeters2 ]
		ifFalse: [ dArcBand radiusMin: aGeoArcBand radiusInMeters2. dArcBand radiusMax: aGeoArcBand radiusInMeters1 ].
	dArcBand aperture: aGeoArcBand apertureInRadians.
	dArcBand orientation: aGeoArcBand orientationInAzimuths.
	^dArcBand
]

{ #category : #processing }
GeoArcBandProcessData >> processUpdatedData: aKey incoming: aGeoArcBand with: aDArcBand context: aContext [
	| dArcBand |
	
	dArcBand := aDArcBand.
	super processUpdatedData: aKey incoming: aGeoArcBand with: dArcBand context: aContext.
	
	aGeoArcBand radiusInMeters1 < aGeoArcBand radiusInMeters2 
		ifTrue: [ dArcBand radiusMin: aGeoArcBand radiusInMeters1. dArcBand radiusMax: aGeoArcBand radiusInMeters2 ]
		ifFalse: [ dArcBand radiusMin: aGeoArcBand radiusInMeters2. dArcBand radiusMax: aGeoArcBand radiusInMeters1 ].
	dArcBand aperture: aGeoArcBand apertureInRadians.
	dArcBand orientation: aGeoArcBand orientationInAzimuths.
	^dArcBand
]
