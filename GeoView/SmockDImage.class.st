"
I am a Display Image.
I am used to display an image on a geo view.
"
Class {
	#name : #SmockDImage,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'image'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
SmockDImage >> copy [
	| copy |
	copy := super copy.
	copy image: self image copy.
	^copy
]

{ #category : #accessing }
SmockDImage >> image [
	^ image
]

{ #category : #accessing }
SmockDImage >> image: anObject [
	image := anObject
]
