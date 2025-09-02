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
		'metersByPixel',
		'offsetInPixels',
		'scale',
		'resolution'
	],
	#category : #'GeoView-Core'
}

{ #category : #accessing }
GeoView2DProjection >> altitudeInMeters [

	self deprecated:'use scale'.
	^ self scale
]

{ #category : #accessing }
GeoView2DProjection >> altitudeInMeters: aNumber [

	self deprecated:'use scale:'.
	self scale: aNumber
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

{ #category : #private }
GeoView2DProjection >> computeResolution: aNumber [

	| viewHeight mapHeight |
	viewHeight := aNumber.
	mapHeight := 2 * self scale.
	mapHeight = 0 ifTrue: [ mapHeight := 1 ].

	^ (viewHeight / mapHeight) asPoint
]

{ #category : #accessing }
GeoView2DProjection >> extentInPixels [

	^ self offsetInPixels * 2
]

{ #category : #accessing }
GeoView2DProjection >> key [

	^ #GeoView2DProjection
]

{ #category : #accessing }
GeoView2DProjection >> metersByPixel [
	"By default return x value of the resolution"

	^ self resolution x
]

{ #category : #accessing }
GeoView2DProjection >> offsetInPixels [

	^ offsetInPixels ifNil: [ offsetInPixels := 0 asPoint ]
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
		* self resolution
		+ self offsetInPixels.
	^ pixel
]

{ #category : #projection }
GeoView2DProjection >> projPixelToCart: aPoint [

	| xCartesian yCartesian xOffset yOffset resX resY |
	
	"Calculate the X offset from the center of the view"
    xOffset := aPoint x - self offsetInPixels x.
	
	"Calculate the Y offset from the center of the view, reversing the Y direction"
    yOffset := self offsetInPixels y - aPoint y.
	
	 "Calculate the Cartesian coordinates based on the center of the view and the resolution"
	resX := (self resolution x = 0 ifTrue:[ 1 ] ifFalse:[ self resolution x ]).
	resY := (self resolution y = 0 ifTrue:[ 1 ] ifFalse:[ self resolution y ]).
	
	xCartesian := (xOffset / (resX)) + self cartesianCenter xInMeters.
  	yCartesian := (yOffset / (resY)) + self cartesianCenter yInMeters.
	
	^ CartesianCoordinates xInMeters: xCartesian yInMeters: yCartesian
]

{ #category : #accessing }
GeoView2DProjection >> resolution [

	^ resolution ifNil: [ resolution := 0 asPoint ]
]

{ #category : #accessing }
GeoView2DProjection >> resolution: aPoint [

	resolution := aPoint
]

{ #category : #accessing }
GeoView2DProjection >> scale [

	^ scale
]

{ #category : #accessing }
GeoView2DProjection >> scale: aNumber [

	scale := aNumber
]

{ #category : #update }
GeoView2DProjection >> updateResolution: aViewSize [

	| res |
	aViewSize ifNil: [ ^ self ].
	aViewSize isPoint ifFalse:[ ^ self ].
	self scale ifNil:[ ^ self ].

	res := self computeResolution: aViewSize y.
	self resolution: res
]
