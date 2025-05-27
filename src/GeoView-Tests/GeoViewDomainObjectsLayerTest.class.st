"
A GeoViewGeoObjectsLayerTest is a test class for testing the behavior of GeoViewGeoObjectsLayer
"
Class {
	#name : #GeoViewDomainObjectsLayerTest,
	#superclass : #TestCase,
	#instVars : [
		'layer'
	],
	#category : #'GeoView-Tests-Cases - Core'
}

{ #category : #running }
GeoViewDomainObjectsLayerTest >> setUp [
	super setUp.

	layer := GeoViewDomainObjectsLayer new
]

{ #category : #tests }
GeoViewDomainObjectsLayerTest >> testHaveDomainObjects [

	self assert: layer haveDomainObjects
]

{ #category : #tests }
GeoViewDomainObjectsLayerTest >> testViewInfos [

	self assert: layer viewInfos isNil.
]
