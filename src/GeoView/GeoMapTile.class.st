"
GeoImage contains element to display a map tile 
"
Class {
	#name : #GeoMapTile,
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
GeoMapTile >> form [

	^ form
]

{ #category : #accessing }
GeoMapTile >> form: anObject [

	form := anObject
]

{ #category : #accessing }
GeoMapTile >> geoBounds [

	^ geoBounds
]

{ #category : #accessing }
GeoMapTile >> geoBounds: aGeoBounds [

	geoBounds := aGeoBounds
]

{ #category : #accessing }
GeoMapTile >> graphicBounds [

	^ graphicBounds
]

{ #category : #accessing }
GeoMapTile >> graphicBounds: anObject [

	graphicBounds := anObject
]

{ #category : #accessing }
GeoMapTile >> isNoPicture [

	isNoPicture ifNil:[ isNoPicture := false].
	^ isNoPicture
]

{ #category : #accessing }
GeoMapTile >> isNoPicture: aBoolean [

	isNoPicture := aBoolean
]

{ #category : #accessing }
GeoMapTile >> level [

	^level
]

{ #category : #accessing }
GeoMapTile >> level: aLevel [

	level := aLevel
]

{ #category : #accessing }
GeoMapTile >> offcenter [

	offcenter ifNil:[ offcenter := 0@0].
	^ offcenter
]

{ #category : #accessing }
GeoMapTile >> offcenter: anOffsetInPixels [

	offcenter := anOffsetInPixels
]

{ #category : #accessing }
GeoMapTile >> pngReference [

	^ pngReference
]

{ #category : #accessing }
GeoMapTile >> pngReference: aFileReference [

	pngReference := aFileReference
]

{ #category : #accessing }
GeoMapTile >> position [

	^ position
]

{ #category : #accessing }
GeoMapTile >> position: aGeoPoint [

	position := aGeoPoint
]

{ #category : #accessing }
GeoMapTile >> scale [

	scale ifNil:[ scale := 1@1].
	^ scale
]

{ #category : #accessing }
GeoMapTile >> scale: aPoint [

	scale := aPoint
]

{ #category : #accessing }
GeoMapTile >> tileXY [

	^ tileXY
]

{ #category : #accessing }
GeoMapTile >> tileXY: anObject [

	tileXY := anObject
]
