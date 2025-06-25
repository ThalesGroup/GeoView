Class {
	#name : #GeoSegment,
	#superclass : #GeoShape,
	#instVars : [
		'toAbsolutePosition'
	],
	#category : #'GeoView-Business - GeoObjects'
}

{ #category : #accessing }
GeoSegment >> fromAbsolutePosition [

	^ self absoluteCoordinates 
]

{ #category : #accessing }
GeoSegment >> fromAbsolutePosition: anAbsoluteCoordinates [

	self absoluteCoordinates: anAbsoluteCoordinates 
]

{ #category : #accessing }
GeoSegment >> toAbsolutePosition [

	^ toAbsolutePosition
]

{ #category : #accessing }
GeoSegment >> toAbsolutePosition: anObject [

	toAbsolutePosition := anObject
]

{ #category : #updating }
GeoSegment >> updateWith: aGeoSegment [

	super updateWith: aGeoSegment.
	self toAbsolutePosition: aGeoSegment toAbsolutePosition copy
]
