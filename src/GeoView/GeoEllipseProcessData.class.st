Class {
	#name : #GeoEllipseProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-Business - GeoObjects'
}

{ #category : #private }
GeoEllipseProcessData >> cartesianRadius1InMetersOf: aGeoEllipse [

	| projectedRadius |
	self flag: 'laborded: todo considere orientation'.
	projectedRadius := GeoViewProjectionUtils
		                   projectedCartesianRadiusFromCenter:
		                   aGeoEllipse absoluteCoordinates
		                   radiusInMeters: aGeoEllipse radius1InMeters
		                   azimuthInDegrees: 0
		                   projection: self processor projection.

	^ projectedRadius
]

{ #category : #private }
GeoEllipseProcessData >> cartesianRadius2InMetersOf: aGeoEllipse [

	| projectedRadius |
	self flag: 'laborded: todo considere orientation'.
	projectedRadius := GeoViewProjectionUtils
		                   projectedCartesianRadiusFromCenter:
		                   aGeoEllipse absoluteCoordinates
		                   radiusInMeters: aGeoEllipse radius2InMeters
		                   azimuthInDegrees: 0
		                   projection: self processor projection.

	^ projectedRadius
]

{ #category : #dShape }
GeoEllipseProcessData >> createDShapeInstance [

	^ SmockDEllipse new
]

{ #category : #processing }
GeoEllipseProcessData >> processCreatedData: aKey incoming: aGeoEllipse with: aDEllipse context: aContext [

	| dEllipse projectedRadius |
	dEllipse := aDEllipse.
	dEllipse := super processCreatedData: aKey incoming: aGeoEllipse with: dEllipse context: aContext.

	projectedRadius := self cartesianRadius1InMetersOf: aGeoEllipse.
	dEllipse radius1: projectedRadius.
	
	projectedRadius := self cartesianRadius2InMetersOf: aGeoEllipse.
	dEllipse radius2: projectedRadius.

	dEllipse orientation: aGeoEllipse orientationInAzimuths.

	^ dEllipse
]

{ #category : #processing }
GeoEllipseProcessData >> processUpdatedData: aKey incoming: aGeoEllipse with: aDEllipse context: aContext [

	| dEllipse |
	dEllipse := aDEllipse.
	super processUpdatedData: aKey incoming: aGeoEllipse with: dEllipse context: aContext.

	dEllipse radius1: aGeoEllipse radiusInMeters1.
	dEllipse radius2: aGeoEllipse radiusInMeters2.
	dEllipse orientation: aGeoEllipse orientationInAzimuths.

	^ dEllipse
]
