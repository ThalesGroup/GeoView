"
A GeoView2DProjectionTest is a test class for testing the behavior of GeoView2DProjection
"
Class {
	#name : #GeoView2DProjectionTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Projection'
}

{ #category : #tests }
GeoView2DProjectionTest >> testInitialize [

	| projection |
	projection := GeoView2DProjection new.
	self assert: projection cartesianCenter equals: CartesianCoordinates zero.
]
