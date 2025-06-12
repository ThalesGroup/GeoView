"
A GeoView2DProjectionTest is a test class for testing the behavior of GeoView2DProjection
"
Class {
	#name : #GeoView2DProjectionTest,
	#superclass : #TestCase,
	#instVars : [
		'projection'
	],
	#category : #'GeoView-Tests-Projections'
}

{ #category : #running }
GeoView2DProjectionTest >> setUp [

	super setUp.

	projection := GeoView2DProjection new
]

{ #category : #tests }
GeoView2DProjectionTest >> testAltitudeInMeters [

	self assert: projection altitudeInMeters equals: (projection defaultAltitudeInMeters).
	
	projection altitudeInMeters: 1.
	self assert: projection altitudeInMeters equals: 1.	
	
	
]

{ #category : #tests }
GeoView2DProjectionTest >> testBoundsInPixels [

	self assert: projection boundsInPixels equals: (0@0 extent: 0@0)
]

{ #category : #tests }
GeoView2DProjectionTest >> testCartesianCenter [

	self assert: projection cartesianCenter equals: CartesianCoordinates zero.
	
	projection cartesianCenter: (CartesianCoordinates xInMeters: 2 yInMeters: 2).
	self assert: projection cartesianCenter equals: (CartesianCoordinates xInMeters: 2 yInMeters: 2).
]

{ #category : #tests }
GeoView2DProjectionTest >> testExtentInPixels [

	self assert: projection extentInPixels equals: 0@0
]

{ #category : #tests }
GeoView2DProjectionTest >> testMetersByPixel [

	self assert: projection metersByPixel equals: 0@0.
	
	projection metersByPixel: 1 asPoint.
	self assert: projection metersByPixel equals: 1 asPoint.
	
	
]

{ #category : #tests }
GeoView2DProjectionTest >> testOffsetInPixels [

	self assert: projection offsetInPixels equals: 0@0.
	
	projection offsetInPixels: 1 asPoint.
	self assert: projection offsetInPixels equals: 1 asPoint.
	
	
]
