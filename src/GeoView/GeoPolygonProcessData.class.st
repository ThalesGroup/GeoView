Class {
	#name : #GeoPolygonProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
GeoPolygonProcessData >> computePosition: aKey incoming: aGeoObject with: aDShape context: aContext [

	| coordinates absoluteCoordinates |
	absoluteCoordinates := aGeoObject absoluteCoordinates.
	absoluteCoordinates
		ifNotNil: [
			absoluteCoordinates isEmpty ifTrue: [
				absoluteCoordinates := AbsoluteCoordinates zero ] ]
		ifNil: [ ^ aDShape ].

	absoluteCoordinates isEmpty ifTrue: [
		absoluteCoordinates := AbsoluteCoordinates zero ].
	coordinates := self processor projection projLatLonToCart:
		               absoluteCoordinates.

	aDShape coordinates: coordinates.
	^ aDShape
]

{ #category : #processing }
GeoPolygonProcessData >> processCreatedData: aKey incoming: aGeoPolygon with: aDPolygon context: aContext [
	| dPolygon points |
	dPolygon := aDPolygon ifNil:[SmockDPolygon new].
	super processCreatedData: aKey incoming: aGeoPolygon with: dPolygon context: aContext.
	
	points := aGeoPolygon absolutePositions collect: [ :e | self processor projection projLatLonToCart: e].
	dPolygon points: points.
	
	^dPolygon
]

{ #category : #processing }
GeoPolygonProcessData >> processUpdatedData: aKey incoming: aGeoPolygon with: aDPolygon context: aContext [
	| dPolygon points |
	dPolygon := aDPolygon.
	super processUpdatedData: aKey incoming: aGeoPolygon with: aDPolygon context: aContext.
	
	points := aGeoPolygon absolutePositions collect: [ :e | self processor projection projLatLonToCart: e].
	dPolygon points: points.
	
	^dPolygon
]
