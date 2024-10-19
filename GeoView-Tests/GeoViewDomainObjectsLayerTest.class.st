"
A GeoViewGeoObjectsLayerTest is a test class for testing the behavior of GeoViewGeoObjectsLayer
"
Class {
	#name : #GeoViewDomainObjectsLayerTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - Core'
}

{ #category : #tests }
GeoViewDomainObjectsLayerTest >> testHaveDomainObjects [

	| layer |
	layer := GeoViewDomainObjectsLayer new.
	self assert: layer haveDomainObjects
]
