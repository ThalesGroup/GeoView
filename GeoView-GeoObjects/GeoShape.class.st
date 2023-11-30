"
I am a geo Shape.
I am used to display a graphical Shape on geo view.
"
Class {
	#name : #GeoShape,
	#superclass : #GeoObject,
	#instVars : [
		'fillColor',
		'strokeColor',
		'strokeWidth',
		'strokePattern'
	],
	#category : #'GeoView-GeoObjects-GeoObjects'
}

{ #category : #accessing }
GeoShape >> fillColor [
	^ fillColor
]

{ #category : #accessing }
GeoShape >> fillColor: anObject [
	fillColor := anObject
]

{ #category : #accessing }
GeoShape >> strokeColor [
	^ strokeColor
]

{ #category : #accessing }
GeoShape >> strokeColor: anObject [
	strokeColor := anObject
]

{ #category : #accessing }
GeoShape >> strokePattern [
	^ strokePattern
]

{ #category : #accessing }
GeoShape >> strokePattern: anObject [
	strokePattern := anObject
]

{ #category : #accessing }
GeoShape >> strokeWidth [
	^ strokeWidth
]

{ #category : #accessing }
GeoShape >> strokeWidth: anObject [
	strokeWidth := anObject
]

{ #category : #updating }
GeoShape >> updateWith: aGeoObject [
	super updateWith: aGeoObject.
	
	self fillColor: aGeoObject fillColor copy.
	self strokeColor: aGeoObject strokeColor copy.
	self strokePattern: aGeoObject strokePattern copy.
	self strokeWidth: aGeoObject strokeWidth copy.
]
