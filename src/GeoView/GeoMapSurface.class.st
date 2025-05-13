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
		'position',
		'isBuffer'
	],
	#category : #'GeoView-Layers'
}

{ #category : #accessing }
GeoMapSurface >> isBuffer [

	isBuffer ifNil:[ isBuffer := false].
	^ isBuffer
]

{ #category : #accessing }
GeoMapSurface >> isBuffer: anObject [

	isBuffer := anObject
]

{ #category : #accessing }
GeoMapSurface >> offcenter [

	offcenter ifNil:[ offcenter := 0@0].
	^ offcenter
]

{ #category : #accessing }
GeoMapSurface >> offcenter: anObject [

	offcenter := anObject
]

{ #category : #accessing }
GeoMapSurface >> position [

	^ position
]

{ #category : #accessing }
GeoMapSurface >> position: anObject [

	position := anObject
]

{ #category : #accessing }
GeoMapSurface >> scale [

	scale ifNil:[ scale := 1@1].
	^ scale
]

{ #category : #accessing }
GeoMapSurface >> scale: anObject [

	scale := anObject
]

{ #category : #accessing }
GeoMapSurface >> surface [

	^ surface
]

{ #category : #accessing }
GeoMapSurface >> surface: anObject [

	surface := anObject
]
