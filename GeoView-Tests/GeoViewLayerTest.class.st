"
A GeoViewLayerTest is a test class for testing the behavior of GeoViewLayer
"
Class {
	#name : #GeoViewLayerTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Core'
}

{ #category : #tests }
GeoViewLayerTest >> testHaveGeoObjects [

	| layer |
	layer := GeoViewLayer new.
	self deny: layer haveGeoObjects.
]
