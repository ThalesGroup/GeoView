"
A geo position indicate a geographical position on a map.
It is composed by a text and an image. 
The image (i.e. a flag) and the text (i.e. ""Paris"") have always the same size of the map, even if the user is changing the scale.

This object is managed by a ProcessData (in this case: GeoPositionProcessData) and it is a good example of how customize the appearence of a ""domain/business object"" with DShape API using device/user draw mode in its own process data.
"
Class {
	#name : #GeoPosition,
	#superclass : #GeoObject,
	#instVars : [
		'text',
		'image'
	],
	#category : #'GeoView-Domain - GeoObjects'
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

{ #category : #updating }
GeoPosition >> updateWith: aGeoObject [

	super updateWith: aGeoObject.

	self image: aGeoObject image.
	self text: aGeoObject text copy
]
