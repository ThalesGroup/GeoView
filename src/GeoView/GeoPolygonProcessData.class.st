Class {
	#name : #GeoPolygonProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-Business - GeoObjects'
}

{ #category : #private }
GeoPolygonProcessData >> computePosition: aKey incoming: aGeoObject with: aDShape context: aContext [
	"Position makes no sense for a Geo polygon"

	^ aDShape
]

{ #category : #dShape }
GeoPolygonProcessData >> createDShapeInstance [

	^ SmockDPolygon new
]

{ #category : #processing }
GeoPolygonProcessData >> processCreatedData: aKey incoming: aGeoPolygon with: aDPolygon context: aContext [
	| dPolygon points |
	
	dPolygon := aDPolygon.
	dPolygon := super processCreatedData: aKey incoming: aGeoPolygon with: dPolygon context: aContext.
	
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
