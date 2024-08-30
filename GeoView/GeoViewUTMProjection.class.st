"
I am a transverse Mercator projection.
"
Class {
	#name : #GeoViewUTMProjection,
	#superclass : #Object,
	#traits : 'TGeoViewMapProjection',
	#classTraits : 'TGeoViewMapProjection classTrait',
	#instVars : [
		'parallel',
		's1',
		's2',
		's3',
		's4',
		'e',
		'e2',
		'e4',
		'e6',
		'k0'
	],
	#category : #'GeoView-Projection'
}

{ #category : #initialization }
GeoViewUTMProjection >> initialize [

	self parallel: 0.
	
	"Constants"
	k0 := 0.9996.
	e := 0.0818192.
	e2 := (2 * WGS84 flattening) - (WGS84 flattening * WGS84 flattening).
	e4 := e raisedTo: 4.
	e6 := e raisedTo: 6.
	s1 := 1 - (e2 / 4) - (e4 * 3 / 64) - (e6 * 5 / 256).
	s2 := (e2 * 3  / 8) + (e4 * 3 / 32) + (e6 * 45 / 1024).
	s3 := (e4 * 15 / 256) + (e6 * 45 / 1024).
	s4 := e6 * 35 / 3072.
]

{ #category : #accessing }
GeoViewUTMProjection >> key [
	^#GeoViewUTMProjection
]

{ #category : #accessing }
GeoViewUTMProjection >> parallel [
	^ parallel
]

{ #category : #accessing }
GeoViewUTMProjection >> parallel: aNumber [
	parallel := aNumber
]

{ #category : #accessing }
GeoViewUTMProjection >> projCartToLatLon: aCartesianCoordinates [
	"Spherical formulas"
	| x y |
	x := aCartesianCoordinates xInMeters.
	y := aCartesianCoordinates yInMeters.

	self flag:'Implémenter la transformation'.
	self halt.

	^ AbsoluteCoordinates new
		latitudeInDegrees: x;
		longitudeInDegrees: y;
		altitudeInMeters: aCartesianCoordinates altitudeInMeters.
]

{ #category : #accessing }
GeoViewUTMProjection >> projLatLonToCart: anAbsoluteCoordinates [
	"Spherical formulas"
	| lat lon v a t c n0 x y s |
	lat := anAbsoluteCoordinates latitudeInRadians.
	lon := anAbsoluteCoordinates longitudeInRadians.
	
	v := 1 / (1 - (e2 * lat sin * lat sin)) sqrt.
	a := (lon - self parallel) * lat cos.
	s := (s1 * lat) - (s2 * (lat * 2) sin) + (s3 * (lat * 4) sin) - (s4 * (lat * 6) sin).
	t := lat tan * lat tan.
	c := lat cos * lat cos * e2 / (1 - e2).
	n0 := lat >= 0 ifTrue: [ 0 ] ifFalse: [ 0"10000e3" ].
	
	x := 500e3 + (k0 * WGS84 semiMajorAxisInMeters * v * (
		a + 
		((1 - t + c) * (a raisedTo: 3) / 6) + 
		((5 - (18 * t) + (t * t)) * (a raisedTo: 5) / 120)
	)).
	
	y := n0 + (k0 * WGS84 semiMajorAxisInMeters *
		(s + 
			(v * lat tan *
			 	((a * a / 2) + 
				((5 - t + (9 * c) + (4 * c * c)) * (a raisedTo: 4) / 24) + 
				((61 - (58 * t) + (t * t)) * (a raisedTo: 6) / 720 ))
			)
		)).
	
	^ CartesianCoordinates new
		xInMeters: x;
		yInMeters: y;
		zInMeters: anAbsoluteCoordinates altitudeInMeters.
]
