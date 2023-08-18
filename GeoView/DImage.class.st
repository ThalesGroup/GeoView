"
I am a Display Image.
I am used to display an image on a geo view.
"
Class {
	#name : #DImage,
	#superclass : #DLeafShape,
	#instVars : [
		'image'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
DImage >> copy [
	| copy |
	copy := super copy.
	copy image: self image copy.
	^copy
]

{ #category : #accessing }
DImage >> image [
	^ image
]

{ #category : #accessing }
DImage >> image: anObject [
	image := anObject
]
