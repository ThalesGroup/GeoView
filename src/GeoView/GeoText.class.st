"
I am a Geo Text.
"
Class {
	#name : #GeoText,
	#superclass : #GeoShape,
	#instVars : [
		'text',
		'smockFont'
	],
	#category : #'GeoView-GeoObjects'
}

{ #category : #accessing }
GeoText >> smockFont [

	^ smockFont
]

{ #category : #accessing }
GeoText >> smockFont: anObject [

	smockFont := anObject
]

{ #category : #accessing }
GeoText >> text [

	^ text 
]

{ #category : #accessing }
GeoText >> text: aString [

	text := aString
]

{ #category : #updating }
GeoText >> updateWith: aGeoText [

	super updateWith: aGeoText.

	self text: aGeoText text copy.
	self smockFont: aGeoText smockFont copy.
]
