Class {
	#name : #GeoMeasuringRuler,
	#superclass : #GeoTool,
	#instVars : [
		'toAbsoluteCoordinates'
	],
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #accessing }
GeoMeasuringRuler >> fromAbsoluteCoordinates [

	^ self absoluteCoordinates
]

{ #category : #accessing }
GeoMeasuringRuler >> fromAbsoluteCoordinates: anAbsoluteCoordinates [

	self absoluteCoordinates: anAbsoluteCoordinates
]

{ #category : #accessing }
GeoMeasuringRuler >> toAbsoluteCoordinates [

	^ toAbsoluteCoordinates
]

{ #category : #accessing }
GeoMeasuringRuler >> toAbsoluteCoordinates: anAbsoluteCoordinates [

	toAbsoluteCoordinates := anAbsoluteCoordinates
]

{ #category : #updating }
GeoMeasuringRuler >> updateWith: aGeoMeasuringRuler [

	super updateWith: aGeoMeasuringRuler.
	self toAbsoluteCoordinates: aGeoMeasuringRuler toAbsoluteCoordinates copy
]
