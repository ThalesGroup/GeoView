"
A GeoViewLayerTest is a test class for testing the behavior of GeoViewLayer
"
Class {
	#name : #AbstractGeoViewLayerTest,
	#superclass : #TestCase,
	#instVars : [
		'layer'
	],
	#category : #'GeoView-Tests-Cases - Core'
}

{ #category : #running }
AbstractGeoViewLayerTest >> setUp [
	super setUp.

	layer := AbstractGeoViewLayer new
]

{ #category : #tests }
AbstractGeoViewLayerTest >> testAnnouncer [

	| announcer |
	announcer := layer announcer.
	self assert: announcer notNil.
	self assert: (announcer isKindOf: Announcer).
	
	"test twice call to check if this is the same object"
	self assert: layer announcer identicalTo: announcer.
	
]

{ #category : #tests }
AbstractGeoViewLayerTest >> testHaveDomainObjects [

	self deny: layer haveDomainObjects
]

{ #category : #tests }
AbstractGeoViewLayerTest >> testHaveGraphicModel [

	self deny: layer haveGraphicModel
]

{ #category : #tests }
AbstractGeoViewLayerTest >> testIsVisible [

	self assert: layer isVisible.

	layer isVisible: false.
	self deny: layer isVisible.

	layer isVisible: true.
	self assert: layer isVisible
]

{ #category : #tests }
AbstractGeoViewLayerTest >> testName [

	self assert: layer name isNil.

	layer name: 'myLayer'.
	self assert: layer name equals: 'myLayer'
]
