"
A GeoViewGeoObjectsLayerTest is a test class for testing the behavior of GeoViewGeoObjectsLayer
"
Class {
	#name : #GeoViewGeoObjectsLayerTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases'
}

{ #category : #tests }
GeoViewGeoObjectsLayerTest >> testHaveGeoObjects [

	| layer |
	layer := GeoViewGeoObjectsLayer new.
	self assert: layer haveGeoObjects
]
