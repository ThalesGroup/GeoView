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
		'scale'
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

{ #category : #testing }
GeoView2DProjection >> haveResolution: aViewSize [
	"Test if the projection have this resolution"

	aViewSize ifNil:[ ^ false ].
	aViewSize isPoint ifFalse:[ ^ false ].
	self scale ifNil:[ ^ false ].
		
	^ self metersByPixel = (self computeResolution: aViewSize y)
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
GeoView2DProjection >> metersByPixel: aPoint [

	metersByPixel := aPoint
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

	| xCartesian yCartesian xOffset yOffset scale scaleX scaleY |
	
	"Calculate the X offset from the center of the view"
    xOffset := aPoint x - self offsetInPixels x.
	
	"Calculate the Y offset from the center of the view, reversing the Y direction"
    yOffset := self offsetInPixels y - aPoint y.
	
	 "Calculate the Cartesian coordinates based on the center of the view and the scale"
	scale := self metersByPixel.
	scaleX := (scale x = 0 ifTrue:[ 1 ] ifFalse:[ scale x ]).
	scaleY := (scale y = 0 ifTrue:[ 1 ] ifFalse:[ scale y ]).
	
	xCartesian := (xOffset / (scaleX)) + self cartesianCenter xInMeters.
  	yCartesian := (yOffset / (scaleY)) + self cartesianCenter yInMeters.
	
	^ CartesianCoordinates xInMeters: xCartesian yInMeters: yCartesian
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

	| resolution |
	aViewSize ifNil: [ ^ self ].
	aViewSize isPoint ifFalse:[ ^ self ].
	self scale ifNil:[ ^ self ].

	resolution := self computeResolution: aViewSize y.
	self metersByPixel: resolution
]
