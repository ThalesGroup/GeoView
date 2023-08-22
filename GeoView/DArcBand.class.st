"
I am a Display Donut.
I am used to display a donut on a geo view.
"
Class {
	#name : #DArcBand,
	#superclass : #DLeafShape,
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
DArcBand >> aperture [
	^ aperture
]

{ #category : #accessing }
DArcBand >> aperture: anObject [
	aperture := anObject
]

{ #category : #copying }
DArcBand >> copy [
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
DArcBand >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DArcBand >> isClosed [
	isClosed isNil ifTrue:[isClosed := false].
	^ isClosed
]

{ #category : #accessing }
DArcBand >> isClosed: anObject [
	isClosed := anObject
]

{ #category : #accessing }
DArcBand >> orientation [
	^ orientation
]

{ #category : #accessing }
DArcBand >> orientation: anObject [
	orientation := anObject
]

{ #category : #accessing }
DArcBand >> radiusMax [
	^ radiusMax
]

{ #category : #accessing }
DArcBand >> radiusMax: anObject [
	radiusMax := anObject
]

{ #category : #accessing }
DArcBand >> radiusMin [
	^ radiusMin
]

{ #category : #accessing }
DArcBand >> radiusMin: anObject [
	radiusMin := anObject
]
