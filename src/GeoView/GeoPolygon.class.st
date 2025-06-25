"
I am a Geo Polygon.
"
Class {
	#name : #GeoPolygon,
	#superclass : #GeoShape,
	#instVars : [
		'absolutePositions'
	],
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #accessing }
GeoPolygon >> absolutePositions [
	^ absolutePositions
]

{ #category : #accessing }
GeoPolygon >> absolutePositions: anObject [
	absolutePositions := anObject
]

{ #category : #updating }
GeoPolygon >> updateWith: aGeoPolyline [
	super updateWith: aGeoPolyline.
	
	self absolutePositions: (aGeoPolyline absolutePositions collect:[ :p | p copy]).
]
