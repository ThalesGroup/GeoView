Class {
	#name : #GeoCircleProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-Business - GeoObjects'
}

{ #category : #private }
GeoCircleProcessData >> cartesianRadiusInMetersOf: aGeoCircle [

	| projectedRadius |
	projectedRadius := GeoViewProjectionUtils
		                   projectedCartesianRadiusFromCenter:
		                   aGeoCircle absoluteCoordinates
		                   radiusInMeters: aGeoCircle radiusInMeters
		                   azimuthInDegrees: 0
		                   projection: self processor projection.

	^ projectedRadius
]

{ #category : #dShape }
GeoCircleProcessData >> createDShapeInstance [

	^ SmockDCircle new
]

{ #category : #processing }
GeoCircleProcessData >> processCreatedData: aKey incoming: aGeoCircle with: aDCircle context: aContext [

	| dCircle projectedRadius |
	dCircle := aDCircle.
	dCircle := super
		           processCreatedData: aKey
		           incoming: aGeoCircle
		           with: dCircle
		           context: aContext.

	projectedRadius := self cartesianRadiusInMetersOf: aGeoCircle.
	dCircle radius: projectedRadius.
	^ dCircle
]

{ #category : #processing }
GeoCircleProcessData >> processUpdatedData: aKey incoming: aGeoCircle with: aDCircle context: aContext [

	| dCircle projectedRadius |
	dCircle := aDCircle.
	super
		processUpdatedData: aKey
		incoming: aGeoCircle
		with: dCircle
		context: aContext.

	projectedRadius := self cartesianRadiusInMetersOf: aGeoCircle.
	dCircle radius: projectedRadius.
	^ dCircle
]
