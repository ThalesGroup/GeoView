"
GeoSurface contains elements to display a map screen
"
Class {
	#name : #GeoMapSurface,
	#superclass : #Object,
	#instVars : [
		'surface',
		'offcenter',
		'scale',
		'position'
	],
	#category : #'GeoView-Layers'
}

{ #category : #accessing }
GeoMapSurface >> offcenter [

	offcenter ifNil:[ offcenter := 0@0].
	^ offcenter
]

{ #category : #accessing }
GeoMapSurface >> offcenter: anOffsetInPixels [

	offcenter := anOffsetInPixels
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
GeoMapSurface >> scale: aScalePoint [

	scale := aScalePoint
]

{ #category : #accessing }
GeoMapSurface >> surface [

	^ surface
]

{ #category : #accessing }
GeoMapSurface >> surface: anObject [

	surface := anObject
]
