"
I am a Geo Circle.
"
Class {
	#name : #GeoCircle,
	#superclass : #GeoShape,
	#instVars : [
		'radiusInMeters'
	],
	#category : #'GeoView-GeoObjects-GeoObjects'
}

{ #category : #accessing }
GeoCircle >> radiusInMeters [
	^ radiusInMeters
]

{ #category : #accessing }
GeoCircle >> radiusInMeters: anObject [
	radiusInMeters := anObject
]

{ #category : #updating }
GeoCircle >> updateWith: aGeoCircle [
	super updateWith: aGeoCircle.
	
	self radiusInMeters: aGeoCircle radiusInMeters.
]
