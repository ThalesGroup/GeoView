"
I am a Display Text.
I am used to display a text on geo view.
"
Class {
	#name : #SmockDText,
	#superclass : #SmockDLeafShape,
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
SmockDText >> copy [
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
SmockDText >> fontEmphasis [
	fontEmphasis isNil ifTrue:[fontEmphasis := GeoFontAttributes fontEmphasisNormal].
	^ fontEmphasis
]

{ #category : #accessing }
SmockDText >> fontEmphasis: anObject [
	fontEmphasis := anObject 
]

{ #category : #accessing }
SmockDText >> fontName [
	^ fontName
]

{ #category : #accessing }
SmockDText >> fontName: anObject [
	fontName := anObject
]

{ #category : #accessing }
SmockDText >> fontSize [
	^ fontSize
]

{ #category : #accessing }
SmockDText >> fontSize: anObject [
	fontSize := anObject
]

{ #category : #accessing }
SmockDText >> fontWeight [
	fontWeight isNil ifTrue:[fontWeight := GeoFontAttributes fontWeightNormal].
	^ fontWeight
]

{ #category : #accessing }
SmockDText >> fontWeight: anObject [
	fontWeight := anObject 
]

{ #category : #accessing }
SmockDText >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
SmockDText >> offsetPx [
	^ offsetPx
]

{ #category : #accessing }
SmockDText >> offsetPx: anObject [
	offsetPx := anObject
]

{ #category : #accessing }
SmockDText >> text [
	^ text
]

{ #category : #accessing }
SmockDText >> text: anObject [
	text := anObject
]
