"
I am a view 2D projection.
This projection use the altitude in meters to determine the resolution in metersByPixels.
"
Class {
	#name : #GeoView2DProjection,
	#superclass : #Object,
	#traits : 'TGeoViewGraphicProjection',
	#classTraits : 'TGeoViewGraphicProjection classTrait',
	#instVars : [
		'cartesianCenter',
		'altitudeInMeters',
		'metersByPixel',
		'offsetInPixels'
	],
	#category : #'GeoView-Projection'
}

{ #category : #accessing }
GeoView2DProjection >> altitudeInMeters [

	^ altitudeInMeters ifNil: [ altitudeInMeters := 1.4816e7 ]
]

{ #category : #accessing }
GeoView2DProjection >> altitudeInMeters: aNumber [

	altitudeInMeters := aNumber
]

{ #category : #accessing }
GeoView2DProjection >> cartesianCenter [

	^ cartesianCenter ifNil: [
		  cartesianCenter := AbsoluteCoordinates zero ]
]

{ #category : #accessing }
GeoView2DProjection >> cartesianCenter: aCartesianCoordinates [

	cartesianCenter := aCartesianCoordinates
]

{ #category : #accessing }
GeoView2DProjection >> extentInPixels [

	^ 0@0 extent: (self offsetInPixels * 2) 
]

{ #category : #accessing }
GeoView2DProjection >> initialize [ 

	super initialize.
]

{ #category : #accessing }
GeoView2DProjection >> key [

	^ #GeoView2DProjection
]

{ #category : #accessing }
GeoView2DProjection >> metersByPixel [

	^ metersByPixel
]

{ #category : #accessing }
GeoView2DProjection >> metersByPixel: aNumber [

	metersByPixel := aNumber
]

{ #category : #accessing }
GeoView2DProjection >> offsetInPixels [

	^ offsetInPixels ifNil: [ offsetInPixels := 0 @ 0 ]
]

{ #category : #accessing }
GeoView2DProjection >> offsetInPixels: aPoint [

	offsetInPixels := aPoint
]

{ #category : #accessing }
GeoView2DProjection >> projCartToPixel: aCartesianCoordinates [

	| point pixel geoCenter |
	point := aCartesianCoordinates asPoint.
	geoCenter := self cartesianCenter asPoint.
	pixel := ((point x @ point y negated) - (geoCenter x @ geoCenter y negated))
		* self metersByPixel
		+ self offsetInPixels.
	^ pixel
]

{ #category : #accessing }
GeoView2DProjection >> projPixelToCart: aPoint [

	| point geoCenter |
	geoCenter := self cartesianCenter asPoint.

	point := self metersByPixel = 0 
		ifTrue:[ (aPoint - self offsetInPixels) + geoCenter] 
		ifFalse:[ (aPoint - self offsetInPixels) / self metersByPixel + geoCenter ].	
	
	^ CartesianCoordinates xInMeters: point x yInMeters: point y
]

{ #category : #accessing }
GeoView2DProjection >> updateResolution: aViewSize [
	| viewHeight mapHeight |
	
	self assert: [aViewSize isNotNil] description: ['[View2DProjection] View size cannot be nil.'].
	viewHeight := aViewSize y.
	mapHeight := 2 * self altitudeInMeters.
	self metersByPixel: viewHeight / mapHeight. 
]
