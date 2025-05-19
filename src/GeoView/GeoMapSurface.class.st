"
GeoSurface contains elements to display a map screen
"
Class {
	#name : #GeoMapSurface,
	#superclass : #Object,
	#instVars : [
		'surface',
		'scale',
		'position',
		'offcenterInPixels',
		'positionCartesian'
	],
	#category : #'GeoView-Layers'
}

{ #category : #accessing }
GeoMapSurface >> offcenterInPixels [

	offcenterInPixels ifNil:[ offcenterInPixels := 0@0].
	^ offcenterInPixels
]

{ #category : #accessing }
GeoMapSurface >> offcenterInPixels: anObject [

	offcenterInPixels := anObject
]

{ #category : #accessing }
GeoMapSurface >> position [

	^ position
]

{ #category : #accessing }
GeoMapSurface >> position: aCartesianCoordinates [

	position := aCartesianCoordinates
]

{ #category : #accessing }
GeoMapSurface >> scale [

	scale ifNil:[ scale := 1@1].
	^ scale
]

{ #category : #accessing }
GeoMapSurface >> scale: aPoint [

	scale := aPoint
]

{ #category : #accessing }
GeoMapSurface >> surface [

	^ surface
]

{ #category : #accessing }
GeoMapSurface >> surface: anObject [

	surface := anObject
]
