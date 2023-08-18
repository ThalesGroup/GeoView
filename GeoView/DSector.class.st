"
I am a Display Sector.
I am used to display a sector on a geo view.

Aperture in radians
Orientation in azimuths (radians)
Radius in meters
"
Class {
	#name : #DSector,
	#superclass : #DLeafShape,
	#instVars : [
		'radius',
		'orientation',
		'aperture'
	],
	#category : #'GeoView-DShape'
}

{ #category : #accessing }
DSector >> aperture [
	^ aperture
]

{ #category : #accessing }
DSector >> aperture: anObject [
	aperture := anObject
]

{ #category : #copying }
DSector >> copy [
	| copy |
	copy := super copy.
	copy radius: self radius.
	copy aperture: self aperture.
	copy orientation: self orientation.
	^copy
]

{ #category : #'initialize-release' }
DSector >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DSector >> orientation [
	^ orientation
]

{ #category : #accessing }
DSector >> orientation: anObject [
	orientation := anObject
]

{ #category : #accessing }
DSector >> radius [
	^ radius
]

{ #category : #accessing }
DSector >> radius: anObject [
	radius := anObject
]
