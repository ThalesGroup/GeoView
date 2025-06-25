"
I am a Geo Polyline.
"
Class {
	#name : #GeoPolyline,
	#superclass : #GeoShape,
	#instVars : [
		'absolutePositions'
	],
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #accessing }
GeoPolyline >> absolutePositions [
	^ absolutePositions
]

{ #category : #accessing }
GeoPolyline >> absolutePositions: anObject [
	absolutePositions := anObject
]

{ #category : #updating }
GeoPolyline >> updateWith: aGeoPolyline [
	super updateWith: aGeoPolyline.
	
	self absolutePositions: (aGeoPolyline absolutePositions collect:[ :p | p copy]).
]
