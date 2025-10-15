"
I am a geo Shape.
I am used to display a graphical Shape on geo view.
"
Class {
	#name : #GeoShape,
	#superclass : #GeoObject,
	#instVars : [
		'fillStyle',
		'strokeStyle'
	],
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #testing }
GeoShape class >> isAbstract [

	^ self == GeoShape
]

{ #category : #accessing }
GeoShape >> fillStyle [

	^ fillStyle
]

{ #category : #accessing }
GeoShape >> fillStyle: anObject [

	fillStyle := anObject
]

{ #category : #accessing }
GeoShape >> strokeStyle [

	^ strokeStyle
]

{ #category : #accessing }
GeoShape >> strokeStyle: anObject [

	strokeStyle := anObject
]

{ #category : #updating }
GeoShape >> updateWith: aGeoObject [

	super updateWith: aGeoObject.

	self fillStyle: aGeoObject fillStyle copy.
	self strokeStyle: aGeoObject strokeStyle copy
]
