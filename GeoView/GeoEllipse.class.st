"
I am a Geo Ellipse.
"
Class {
	#name : #GeoEllipse,
	#superclass : #GeoShape,
	#instVars : [
		'radiusInMeters1',
		'radiusInMeters2'
	],
	#category : #'GeoView-GeoObjects'
}

{ #category : #accessing }
GeoEllipse >> radiusInMeters1 [
	^ radiusInMeters1
]

{ #category : #accessing }
GeoEllipse >> radiusInMeters1: anObject [
	radiusInMeters1 := anObject
]

{ #category : #accessing }
GeoEllipse >> radiusInMeters2 [
	^ radiusInMeters2
]

{ #category : #accessing }
GeoEllipse >> radiusInMeters2: anObject [
	radiusInMeters2 := anObject
]

{ #category : #updating }
GeoEllipse >> updateWith: aGeoEllipse [
	super updateWith: aGeoEllipse.
	
	self radiusInMeters1: aGeoEllipse radiusInMeters1.
	self radiusInMeters2: aGeoEllipse radiusInMeters2.
]
