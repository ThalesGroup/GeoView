"
A geo position is composed by a text and an image
"
Class {
	#name : #GeoPosition,
	#superclass : #GeoShape,
	#instVars : [
		'text',
		'image'
	],
	#category : #'GeoView-Business - GeoObjects'
}

{ #category : #accessing }
GeoPosition >> image [

	^ image
]

{ #category : #accessing }
GeoPosition >> image: anObject [

	image := anObject
]

{ #category : #accessing }
GeoPosition >> text [

	^ text
]

{ #category : #accessing }
GeoPosition >> text: anObject [

	text := anObject
]
