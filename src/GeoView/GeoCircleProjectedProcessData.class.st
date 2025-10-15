Class {
	#name : #GeoCircleProjectedProcessData,
	#superclass : #GeoShapeProcessData,
	#traits : 'TGeoProjectorProcessData',
	#classTraits : 'TGeoProjectorProcessData classTrait',
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #private }
GeoCircleProjectedProcessData >> createCartesianPolylinesFor: aGeoCircle [

	| center radius polylines |
	center := aGeoCircle absoluteCoordinates.
	radius := aGeoCircle radiusInMeters.

	polylines := self projectCircle: center radiusInMeters: radius.
	^ polylines
]

{ #category : #dShape }
GeoCircleProjectedProcessData >> createDShapeInstance [

	^ SmockDMultiPolylines new
]

{ #category : #processing }
GeoCircleProjectedProcessData >> processCreatedData: aKey incoming: aGeoCircle with: aDMultiPolylines context: aContext [

	| dMultiPolylines polylines |
	dMultiPolylines := aDMultiPolylines.
	dMultiPolylines := super
		                   processCreatedData: aKey
		                   incoming: aGeoCircle
		                   with: dMultiPolylines
		                   context: aContext.
		
	dMultiPolylines coordinates: nil.
	dMultiPolylines removePolylines.
		
	polylines := self createCartesianPolylinesFor: aGeoCircle.
	dMultiPolylines addPolylines: polylines.

	^ dMultiPolylines
]

{ #category : #processing }
GeoCircleProjectedProcessData >> processUpdatedData: aKey incoming: aGeoCircle with: aDMultiPolylines context: aContext [

	| dMultiPolylines polylines |
	dMultiPolylines := aDMultiPolylines.
	super
		processCreatedData: aKey
		incoming: aGeoCircle
		with: dMultiPolylines
		context: aContext.

	dMultiPolylines removePolylines.

	polylines := self createCartesianPolylinesFor: aGeoCircle.
	dMultiPolylines addPolylines: polylines.

	^ dMultiPolylines
]
