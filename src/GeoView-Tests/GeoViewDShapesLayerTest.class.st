"
A GeoViewDShapesLayerTest is a test class for testing the behavior of GeoViewDShapesLayer
"
Class {
	#name : #GeoViewDShapesLayerTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - Core'
}

{ #category : #tests }
GeoViewDShapesLayerTest >> testAddDShape [

	| layer shape |
	layer := GeoViewDShapesLayer new.
	shape := SmockDCircle key: 1.
	layer addDShape: shape.
	self assert: layer userModel size equals: 1.
	self assert: layer userModel values first equals: shape.
	self assert: layer graphicModel getDatas size equals: 1.
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testHaveDomainObjects [

	| layer |
	layer := GeoViewDShapesLayer new.
	self deny: layer haveDomainObjects
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testRemoveDShape [

	| layer shape |
	layer := GeoViewDShapesLayer new.
	shape := SmockDCircle key: 1.
	layer addDShape: shape.
	layer updateDShape: ((shape) radius: 10; yourself).
	layer removeDShape: shape.
	self assert: layer userModel size equals: 0.
	self assert: layer graphicModel getDatas size equals: 0.
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testUpdateDShape [

	| layer shape |
	layer := GeoViewDShapesLayer new.
	shape := SmockDCircle key: 1.
	layer addDShape: shape.
	layer updateDShape: ((shape) radius: 10; yourself).
	self assert: layer userModel size equals: 1.
	self assert: layer userModel values first equals: shape.
	self assert: layer graphicModel getDatas size equals: 1.
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testUserModel [

	| layer |
	layer := GeoViewDShapesLayer new.
	self assert: layer userModel isEmpty
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testViewInfos [

	| layer |
	layer := GeoViewDShapesLayer new.
	self assert: layer viewInfos isNil.
]
