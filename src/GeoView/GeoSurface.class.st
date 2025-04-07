Class {
	#name : #GeoSurface,
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
GeoSurface >> isBuffer [

	isBuffer ifNil:[ isBuffer := false].
	^ isBuffer
]

{ #category : #accessing }
GeoSurface >> isBuffer: anObject [

	isBuffer := anObject
]

{ #category : #accessing }
GeoSurface >> offcenter [

	offcenter ifNil:[ offcenter := 0@0].
	^ offcenter
]

{ #category : #accessing }
GeoSurface >> offcenter: anObject [

	offcenter := anObject
]

{ #category : #accessing }
GeoSurface >> position [

	^ position
]

{ #category : #accessing }
GeoSurface >> position: anObject [

	position := anObject
]

{ #category : #accessing }
GeoSurface >> scale [

	scale ifNil:[ scale := 1@1].
	^ scale
]

{ #category : #accessing }
GeoSurface >> scale: anObject [

	scale := anObject
]

{ #category : #accessing }
GeoSurface >> surface [

	^ surface
]

{ #category : #accessing }
GeoSurface >> surface: anObject [

	surface := anObject
]
