"
I am a Display Text.
I am used to display a text on geo view.
"
Class {
	#name : #DText,
	#superclass : #DLeafShape,
	#instVars : [
		'text',
		'fontName',
		'fontSize',
		'fontEmphasis',
		'fontWeight',
		'offsetPx'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
DText >> copy [
	| copy |
	copy := super copy.
	copy text: self text copy.
	copy fontName: self fontName.
	copy fontSize: self fontSize.
	copy fontWeight: self fontWeight.
	copy fontEmphasis: self fontEmphasis.
	^copy
]

{ #category : #accessing }
DText >> fontEmphasis [
	fontEmphasis isNil ifTrue:[fontEmphasis := GeoFontAttributes fontEmphasisNormal].
	^ fontEmphasis
]

{ #category : #accessing }
DText >> fontEmphasis: anObject [
	fontEmphasis := anObject 
]

{ #category : #accessing }
DText >> fontName [
	^ fontName
]

{ #category : #accessing }
DText >> fontName: anObject [
	fontName := anObject
]

{ #category : #accessing }
DText >> fontSize [
	^ fontSize
]

{ #category : #accessing }
DText >> fontSize: anObject [
	fontSize := anObject
]

{ #category : #accessing }
DText >> fontWeight [
	fontWeight isNil ifTrue:[fontWeight := GeoFontAttributes fontWeightNormal].
	^ fontWeight
]

{ #category : #accessing }
DText >> fontWeight: anObject [
	fontWeight := anObject 
]

{ #category : #accessing }
DText >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DText >> offsetPx [
	^ offsetPx
]

{ #category : #accessing }
DText >> offsetPx: anObject [
	offsetPx := anObject
]

{ #category : #accessing }
DText >> text [
	^ text
]

{ #category : #accessing }
DText >> text: anObject [
	text := anObject
]
