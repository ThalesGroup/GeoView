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
	#category : #'GeoView-Projections'
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
		  cartesianCenter := CartesianCoordinates zero ]
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

	| xCartesian yCartesian xOffset yOffset scale |
	
	"Calculate the X offset from the center of the view"
    xOffset := aPoint x - self offsetInPixels x.
	
	"Calculate the Y offset from the center of the view, reversing the Y direction"
    yOffset := self offsetInPixels y - aPoint y.
	
	 "Calculate the Cartesian coordinates based on the center of the view and the scale"
	scale := self metersByPixel.
	scale = 0 ifTrue:[
		xCartesian := xOffset + self cartesianCenter xInMeters.
  	 	yCartesian := yOffset + self cartesianCenter yInMeters.
	] ifFalse:[
		xCartesian := (xOffset / scale) + self cartesianCenter xInMeters.
  	 	yCartesian := (yOffset / scale) + self cartesianCenter yInMeters.
	].
	
	^ CartesianCoordinates xInMeters: xCartesian yInMeters: yCartesian
]

{ #category : #accessing }
GeoView2DProjection >> updateResolution: aViewSize [
	| viewHeight mapHeight |
	
	self assert: [aViewSize isNotNil] description: ['[View2DProjection] View size cannot be nil.'].
	viewHeight := aViewSize y.
	mapHeight := 2 * self altitudeInMeters.
	self metersByPixel: viewHeight / mapHeight. 
]
