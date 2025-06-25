"
I am a Geo Rectangle.
"
Class {
	#name : #GeoRectangle,
	#superclass : #GeoShape,
	#instVars : [
		'lengthInMeters1',
		'lengthInMeters2'
	],
	#category : #'GeoView-Business - GeoObjects'
}

{ #category : #accessing }
GeoRectangle >> lengthInMeters1 [
	^ lengthInMeters1
]

{ #category : #accessing }
GeoRectangle >> lengthInMeters1: anObject [
	lengthInMeters1 := anObject
]

{ #category : #accessing }
GeoRectangle >> lengthInMeters2 [
	^ lengthInMeters2
]

{ #category : #accessing }
GeoRectangle >> lengthInMeters2: anObject [
	lengthInMeters2 := anObject
]

{ #category : #updating }
GeoRectangle >> updateWith: aGeoRectangle [
	super updateWith: aGeoRectangle.
	
	self lengthInMeters1: aGeoRectangle lengthInMeters1.
	self lengthInMeters2: aGeoRectangle lengthInMeters2.
]
