"
A GeoViewProjectionChangesTest is a test class for testing the behavior of GeoViewProjectionChanges
"
Class {
	#name : #GeoViewProjectionChangesTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases'
}

{ #category : #tests }
GeoViewProjectionChangesTest >> testInitialize [

	| changes |
	changes := GeoViewProjectionChanges new.
	self deny: changes isCenterChanged.
	self deny: changes isExtentChanged.
	self deny: changes isMapProjectionChange.
	self deny: changes isResolutionChanged.
	self deny: changes isScaleChanged.
]
