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

	self deprecated: 'use SmockFont'.
	fontEmphasis isNil ifTrue:[fontEmphasis := GeoFontAttributes fontEmphasisNormal].
	^ fontEmphasis
]

{ #category : #accessing }
GeoText >> fontEmphasis: anObject [

	self deprecated: 'use SmockFont'.
	fontEmphasis := anObject 
]

{ #category : #accessing }
GeoText >> fontName [

	self deprecated: 'use SmockFont'.
	^ fontName
]

{ #category : #accessing }
GeoText >> fontName: anObject [

	self deprecated: 'use SmockFont'.
	fontName := anObject 
]

{ #category : #accessing }
GeoText >> fontSize [

	self deprecated: 'use SmockFont'.
	^ fontSize
]

{ #category : #accessing }
GeoText >> fontSize: anObject [

	self deprecated: 'use SmockFont'.
	fontSize := anObject 
]

{ #category : #accessing }
GeoText >> fontWeight [

	self deprecated: 'use SmockFont'.
	fontWeight isNil ifTrue:[fontWeight := GeoFontAttributes fontWeightNormal].
	^ fontWeight
]

{ #category : #accessing }
GeoText >> fontWeight: anObject [

	self deprecated: 'use SmockFont'.
	fontWeight := anObject 
]

{ #category : #accessing }
GeoText >> text [

	self deprecated: 'use SmockFont'.
	^ text 
]

{ #category : #accessing }
GeoText >> text: anObject [

	self deprecated: 'use SmockFont'.
	text := anObject
]

{ #category : #updating }
GeoText >> updateWith: aGeoText [

	super updateWith: aGeoText.

	self text: aGeoText text copy.
	self fontName: aGeoText fontName.
	self fontSize: aGeoText fontSize.
	self fontWeight: aGeoText fontWeight.
	self fontEmphasis: aGeoText fontEmphasis
]
