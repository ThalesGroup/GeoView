"
A GeoViewGeoObjectsLayerTest is a test class for testing the behavior of GeoViewGeoObjectsLayer
"
Class {
	#name : #GeoViewDomainObjectsLayerTest,
	#superclass : #AbstractGeoViewGraphicModelLayerTest,
	#category : #'GeoView-Tests-Core'
}

{ #category : #running }
GeoViewDomainObjectsLayerTest >> layerClass [ 

	^ GeoViewDomainObjectsLayer
]

{ #category : #tests }
GeoViewDomainObjectsLayerTest >> testHaveDomainObjects [

	self assert: layer haveDomainObjects
]

{ #category : #tests }
GeoViewDomainObjectsLayerTest >> testViewInfos [

	self assert: layer viewInfos isNil.
]
