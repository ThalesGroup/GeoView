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
GeoView2DProjectionTest >> testHaveResolution [

	"not supported values"
	self deny: (projection haveResolution: nil).
	self deny: (projection haveResolution: 1).
	
	"supported values"
	self deny: (projection haveResolution: 1 asPoint).
	
	"setup scale to work"
	projection scale: 1000000.
	projection updateResolution: 100@100.
	self assert: (projection haveResolution: (100@100)).
	self deny: (projection haveResolution: (50@50))
]

{ #category : #tests }
GeoView2DProjectionTest >> testMetersByPixel [

	self assert: projection metersByPixel equals: 0 asPoint.
	
	projection metersByPixel: 1 asPoint.
	self assert: projection metersByPixel equals: 1 asPoint.
	
	
]

{ #category : #tests }
GeoView2DProjectionTest >> testOffsetInPixels [

	self assert: projection offsetInPixels equals: 0@0.
	
	projection offsetInPixels: 1 asPoint.
	self assert: projection offsetInPixels equals: 1 asPoint.
	
	
]

{ #category : #tests }
GeoView2DProjectionTest >> testScale [

	self assert: projection scale isNil.
	
	projection scale: 1.
	self assert: projection scale equals: 1.	
	
	
]

{ #category : #tests }
GeoView2DProjectionTest >> testUpdateResolution [

	"not supported values"
	projection updateResolution: nil.
	self assert: projection metersByPixel equals: 0 asPoint.
	
	projection updateResolution: 1.
	self assert: projection metersByPixel equals: 0 asPoint.
	
	projection updateResolution: 100@100.
	self assert: projection metersByPixel equals: 0 asPoint.
	
	"setup a scale to update"
	projection scale: 1000000.
	
	"not supported values"
	projection updateResolution: nil.
	self assert: projection metersByPixel equals: 0 asPoint.
	
	projection updateResolution: 1.
	self assert: projection metersByPixel equals: 0 asPoint.
	
	"supported values"
	projection updateResolution: 100@100.
	self assert: projection metersByPixel equals: (1/20000 asPoint).
]
