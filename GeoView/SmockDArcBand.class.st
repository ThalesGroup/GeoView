"
I am a Display Donut.
I am used to display a donut on a geo view.
"
Class {
	#name : #SmockDArcBand,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'radiusMin',
		'radiusMax',
		'orientation',
		'aperture',
		'isClosed'
	],
	#category : #'GeoView-DShape'
}

{ #category : #accessing }
SmockDArcBand >> aperture [
	^ aperture
]

{ #category : #accessing }
SmockDArcBand >> aperture: anObject [
	aperture := anObject
]

{ #category : #copying }
SmockDArcBand >> copy [
	| copy |
	copy := super copy.
	copy radiusMin: self radiusMin.
	copy radiusMax: self radiusMax.
	copy aperture: self aperture.
	copy orientation: self orientation.
	copy isClosed: self isClosed.
	^copy
]

{ #category : #accessing }
SmockDArcBand >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
SmockDArcBand >> isClosed [
	isClosed isNil ifTrue:[isClosed := false].
	^ isClosed
]

{ #category : #accessing }
SmockDArcBand >> isClosed: anObject [
	isClosed := anObject
]

{ #category : #accessing }
SmockDArcBand >> orientation [
	^ orientation
]

{ #category : #accessing }
SmockDArcBand >> orientation: anObject [
	orientation := anObject
]

{ #category : #accessing }
SmockDArcBand >> radiusMax [
	^ radiusMax
]

{ #category : #accessing }
SmockDArcBand >> radiusMax: anObject [
	radiusMax := anObject
]

{ #category : #accessing }
SmockDArcBand >> radiusMin [
	^ radiusMin
]

{ #category : #accessing }
SmockDArcBand >> radiusMin: anObject [
	radiusMin := anObject
]
