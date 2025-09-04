"
A GeoViewDShapesLayerTest is a test class for testing the behavior of GeoViewDShapesLayer
"
Class {
	#name : #GeoViewDShapesLayerTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Core'
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
GeoViewDShapesLayerTest >> testAddDShapes [

	| layer shape1 shape2 |
	layer := GeoViewDShapesLayer new.	
	shape1 := SmockDCircle key: 1.
	shape2 := SmockDCircle key: 2.
	layer addDShapes: (OrderedCollection with: shape1 with: shape2).
	
	self assert: layer userModel size equals: 2.
	self assert: layer userModel values first equals: shape1.
	self assert: layer graphicModel getDatas size equals: 2.
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
GeoViewDShapesLayerTest >> testRemoveDShapes [

	| layer shape1 shape2 |
	layer := GeoViewDShapesLayer new.
	shape1 := SmockDCircle key: 1.
	shape2 := SmockDCircle key: 2.
	layer addDShape: shape1; addDShape: shape2.
	
	layer removeDShapes: (OrderedCollection with: shape1 with: shape2).
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
GeoViewDShapesLayerTest >> testUpdateDShapes [

	| layer shape1 shape2 |
	layer := GeoViewDShapesLayer new.
	shape1 := SmockDCircle key: 1.
	shape2 := SmockDCircle key: 2.
	layer addDShape: shape1; addDShape: shape2.
	
	layer updateDShapes: (OrderedCollection with: shape1 with: shape2).
	self assert: layer userModel size equals: 2.
	self assert: layer userModel values first equals: shape1.
	self assert: layer graphicModel getDatas size equals: 2.
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
