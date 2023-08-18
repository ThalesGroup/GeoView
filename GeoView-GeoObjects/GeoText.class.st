"
I am a Geo Text.
"
Class {
	#name : #GeoText,
	#superclass : #GeoShape,
	#instVars : [
		'text',
		'fontWeight',
		'fontEmphasis',
		'fontSize',
		'fontName'
	],
	#category : #'GeoView-GeoObjects-GeoObjects'
}

{ #category : #accessing }
GeoText >> fontEmphasis [
	fontEmphasis isNil ifTrue:[fontEmphasis := GeoFontAttributes fontEmphasisNormal].
	^ fontEmphasis
]

{ #category : #accessing }
GeoText >> fontEmphasis: anObject [
	fontEmphasis := anObject 
]

{ #category : #accessing }
GeoText >> fontName [
	^ fontName
]

{ #category : #accessing }
GeoText >> fontName: anObject [
	fontName := anObject 
]

{ #category : #accessing }
GeoText >> fontSize [
	^ fontSize
]

{ #category : #accessing }
GeoText >> fontSize: anObject [
	fontSize := anObject 
]

{ #category : #accessing }
GeoText >> fontWeight [
	fontWeight isNil ifTrue:[fontWeight := GeoFontAttributes fontWeightNormal].
	^ fontWeight
]

{ #category : #accessing }
GeoText >> fontWeight: anObject [
	fontWeight := anObject 
]

{ #category : #accessing }
GeoText >> text [
	^ text 
]

{ #category : #accessing }
GeoText >> text: anObject [
	text := anObject
]

{ #category : #updating }
GeoText >> updateWith: aGeoText [
	super updateWith: aGeoText.
	
	self text: aGeoText text copy.
	self fontName: aGeoText fontName.
	self fontSize: aGeoText fontSize.
	self fontWeight: aGeoText fontWeight.
	self fontEmphasis: aGeoText fontEmphasis.
]
