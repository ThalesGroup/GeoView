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
	#category : #'GeoView-Core'
}

{ #category : #accessing }
GeoView2DProjection >> altitudeInMeters [

	^ altitudeInMeters ifNil: [
		  altitudeInMeters := self defaultAltitudeInMeters ]
]

{ #category : #accessing }
GeoView2DProjection >> altitudeInMeters: aNumber [

	altitudeInMeters := aNumber
]

{ #category : #accessing }
GeoView2DProjection >> boundsInPixels [

	^ 0@0 extent: self extentInPixels 
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

{ #category : #initialization }
GeoView2DProjection >> defaultAltitudeInMeters [

	^ 1.4816e7
]

{ #category : #accessing }
GeoView2DProjection >> extentInPixels [

	^ self offsetInPixels * 2
]

{ #category : #accessing }
GeoView2DProjection >> haveResolution: aViewSize [

	| viewHeight mapHeight |
	viewHeight := aViewSize y.
	mapHeight := 2 * self altitudeInMeters.
	mapHeight = 0 ifTrue:[ mapHeight := 1 ].
	
	^ self metersByPixel = (viewHeight / mapHeight)
]

{ #category : #accessing }
GeoView2DProjection >> key [

	^ #GeoView2DProjection
]

{ #category : #accessing }
GeoView2DProjection >> metersByPixel [

	^ metersByPixel ifNil: [ metersByPixel := 0 @ 0 ]
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

{ #category : #projection }
GeoView2DProjection >> projCartToPixel: aCartesianCoordinates [

	| point pixel geoCenter |
	
	aCartesianCoordinates ifNil:[ ^ nil ].
	
	point := aCartesianCoordinates asPoint.
	geoCenter := self cartesianCenter asPoint.
	pixel := ((point x @ point y negated) - (geoCenter x @ geoCenter y negated))
		* self metersByPixel
		+ self offsetInPixels.
	^ pixel
]

{ #category : #projection }
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
GeoView2DProjection >> updateResolution: aPoint [
	| viewHeight mapHeight |
	
	self assert: [aPoint isNotNil] description: ['[GeoView] 2D projection view size cannot be nil.'].
	viewHeight := aPoint y.
	mapHeight := 2 * self altitudeInMeters.
	mapHeight = 0 ifTrue:[ mapHeight := 1 ].
	
	self metersByPixel: viewHeight / mapHeight. 
]
