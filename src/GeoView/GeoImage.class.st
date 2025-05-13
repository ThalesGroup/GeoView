"
GeoImage contains element to display a map tile 
"
Class {
	#name : #GeoImage,
	#superclass : #Object,
	#instVars : [
		'form',
		'offcenter',
		'position',
		'isNoPicture',
		'tileXY',
		'scale',
		'graphicBounds',
		'geoBounds',
		'pngReference',
		'level'
	],
	#category : #'GeoView-Layers'
}

{ #category : #accessing }
GeoImage >> form [

	^ form
]

{ #category : #accessing }
GeoImage >> form: anObject [

	form := anObject
]

{ #category : #accessing }
GeoImage >> geoBounds [

	^ geoBounds
]

{ #category : #accessing }
GeoImage >> geoBounds: aGeoBounds [

	geoBounds := aGeoBounds
]

{ #category : #accessing }
GeoImage >> graphicBounds [

	^ graphicBounds
]

{ #category : #accessing }
GeoImage >> graphicBounds: anObject [

	graphicBounds := anObject
]

{ #category : #accessing }
GeoImage >> isNoPicture [

	isNoPicture ifNil:[ isNoPicture := false].
	^ isNoPicture
]

{ #category : #accessing }
GeoImage >> isNoPicture: anObject [

	isNoPicture := anObject
]

{ #category : #accessing }
GeoImage >> level [

	^level
]

{ #category : #accessing }
GeoImage >> level: aLevel [

	level := aLevel
]

{ #category : #accessing }
GeoImage >> offcenter [

	offcenter ifNil:[ offcenter := 0@0].
	^ offcenter
]

{ #category : #accessing }
GeoImage >> offcenter: anObject [

	offcenter := anObject
]

{ #category : #accessing }
GeoImage >> pngReference [

	^ pngReference
]

{ #category : #accessing }
GeoImage >> pngReference: aFileReference [

	pngReference := aFileReference
]

{ #category : #accessing }
GeoImage >> position [

	^ position
]

{ #category : #accessing }
GeoImage >> position: anObject [

	position := anObject
]

{ #category : #accessing }
GeoImage >> scale [

	scale ifNil:[ scale := 1@1].
	^ scale
]

{ #category : #accessing }
GeoImage >> scale: anObject [

	scale := anObject
]

{ #category : #accessing }
GeoImage >> tileXY [

	^ tileXY
]

{ #category : #accessing }
GeoImage >> tileXY: anObject [

	tileXY := anObject
]
