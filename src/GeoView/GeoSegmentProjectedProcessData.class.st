"
labordep: this class is POC, need to be refactored with standard processData and setup with isGeoProjectedShape: true/false parameter 
"
Class {
	#name : #GeoSegmentProjectedProcessData,
	#superclass : #GeoShapeProcessData,
	#traits : 'TGeoProjectorProcessData',
	#classTraits : 'TGeoProjectorProcessData classTrait',
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #computing }
GeoSegmentProjectedProcessData >> computePosition: aKey incoming: aGeoObject with: aDShape context: aContext [
	"Position makes no sense for this kind of projected object"

	^ aDShape
]

{ #category : #private }
GeoSegmentProjectedProcessData >> createCartesianPolylinesFor: aGeoSegment [

	| from to polylines |
	from := aGeoSegment fromAbsolutePosition.
	to := aGeoSegment toAbsolutePosition.

	polylines := self projectGeodesicFrom: from to: to.
	^ polylines
]

{ #category : #dShape }
GeoSegmentProjectedProcessData >> createDShapeInstance [

	^ SmockDMultiPolylines new
]

{ #category : #processing }
GeoSegmentProjectedProcessData >> processCreatedData: aKey incoming: aGeoSegment with: aDMultiPolylines context: aContext [

	| dMultiPolylines polylines |
	dMultiPolylines := aDMultiPolylines.
	dMultiPolylines := super
		                   processCreatedData: aKey
		                   incoming: aGeoSegment
		                   with: dMultiPolylines
		                   context: aContext.
		
	dMultiPolylines coordinates: nil.
	dMultiPolylines removePolylines.
		
	polylines := self createCartesianPolylinesFor: aGeoSegment.
	dMultiPolylines addPolylines: polylines.

	^ dMultiPolylines
]

{ #category : #processing }
GeoSegmentProjectedProcessData >> processUpdatedData: aKey incoming: aGeoSegment with: aDMultiPolylines context: aContext [

	| dMultiPolylines polylines |
	dMultiPolylines := aDMultiPolylines.
	super
		processCreatedData: aKey
		incoming: aGeoSegment
		with: dMultiPolylines
		context: aContext.

	dMultiPolylines removePolylines.

	polylines := self createCartesianPolylinesFor: aGeoSegment.
	dMultiPolylines addPolylines: polylines.

	^ dMultiPolylines
]
