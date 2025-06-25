Class {
	#name : #GeoSegmentProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-Business - GeoObjects'
}

{ #category : #dShape }
GeoSegmentProcessData >> createDShapeInstance [

	^ SmockDSegment new
]

{ #category : #processing }
GeoSegmentProcessData >> processCreatedData: aKey incoming: aGeoSegment with: aDSegment context: aContext [
	| dSegment |
	
	dSegment := aDSegment.
	dSegment := super processCreatedData: aKey incoming: aGeoSegment with: dSegment context: aContext.

	aGeoSegment toAbsolutePosition ifNotNil:[ :e |
		dSegment coordinates2: (self processor projection projLatLonToCart: e).
	].

	^ dSegment
]

{ #category : #processing }
GeoSegmentProcessData >> processUpdatedData: aKey incoming: aGeoSegment with: aDSegment context: aContext [
	| dSegment |
	
	dSegment := aDSegment.
	super processUpdatedData: aKey incoming: aGeoSegment with: dSegment context: aContext.

	dSegment coordinates2: (aGeoSegment toAbsolutePosition ifNotNil:[ :e |
		self processor projection projLatLonToCart: e.
	]).

	^ dSegment
]
