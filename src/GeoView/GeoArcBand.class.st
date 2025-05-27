"
I am a Geo Arc Band.
"
Class {
	#name : #GeoArcBand,
	#superclass : #GeoShape,
	#instVars : [
		'radiusInMeters1',
		'radiusInMeters2',
		'orientationInAzimuths',
		'apertureInRadians'
	],
	#category : #'GeoView-GeoObjects'
}

{ #category : #accessing }
GeoArcBand >> apertureInRadians [
	^ apertureInRadians
]

{ #category : #accessing }
GeoArcBand >> apertureInRadians: anObject [
	apertureInRadians := anObject
]

{ #category : #accessing }
GeoArcBand >> orientationInAzimuths [

	^ orientationInAzimuths
]

{ #category : #accessing }
GeoArcBand >> orientationInAzimuths: anObject [

	orientationInAzimuths := anObject
]

{ #category : #accessing }
GeoArcBand >> radiusInMeters1 [
	^ radiusInMeters1
]

{ #category : #accessing }
GeoArcBand >> radiusInMeters1: anObject [
	radiusInMeters1 := anObject
]

{ #category : #accessing }
GeoArcBand >> radiusInMeters2 [
	^ radiusInMeters2
]

{ #category : #accessing }
GeoArcBand >> radiusInMeters2: anObject [
	radiusInMeters2 := anObject
]

{ #category : #updating }
GeoArcBand >> updateWith: aGeoArcBand [
	super updateWith: aGeoArcBand.
	
	self radiusInMeters1: aGeoArcBand radiusInMeters1.
	self radiusInMeters2: aGeoArcBand radiusInMeters2.
	self orientationInAzimuths: aGeoArcBand orientationInAzimuths.
	self apertureInRadians: aGeoArcBand apertureInRadians.
]
