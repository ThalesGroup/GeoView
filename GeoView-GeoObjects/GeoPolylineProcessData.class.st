Class {
	#name : #GeoPolylineProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-GeoObjects-ProcessData'
}

{ #category : #processing }
GeoPolylineProcessData >> processCreatedData: aKey incoming: aGeoPolyline with: aDPolyline context: aContext [
	| dPolyline points |
	dPolyline := aDPolyline ifNil:[DPolyline new].
	super processCreatedData: aKey incoming: aGeoPolyline with: dPolyline context: aContext.
	
	points := aGeoPolyline absolutePositions collect: [ :e | self processor projection projLatLonToCart: e].
	dPolyline points: points.
	
	^dPolyline
]

{ #category : #processing }
GeoPolylineProcessData >> processUpdatedData: aKey incoming: aGeoPolyline with: aDPolyline context: aContext [
	| points |
	super processUpdatedData: aKey incoming: aGeoPolyline with: aDPolyline context: aContext.
	
	points := aGeoPolyline absolutePositions collect: [ :e | self processor projection projLatLonToCart: e].
	aDPolyline points: points.
	
	^aDPolyline
]
