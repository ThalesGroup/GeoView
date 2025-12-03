"
A GeoViewDShapesLayerTest is a test class for testing the behavior of GeoViewDShapesLayer
"
Class {
	#name : #GeoViewDShapesLayerTest,
	#superclass : #AbstractGeoViewGraphicModelLayerTest,
	#category : #'GeoView-Tests-Core'
}

{ #category : #running }
GeoViewDShapesLayerTest >> layerClass [

	^ GeoViewDShapesLayer
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testAddDShape [

	| shape |
	shape := SmockDCircle key: 1.
	layer addDShape: shape.
	self assert: layer displayModel size equals: 1.
	self assert: layer displayModel values first equals: shape.
	self assert: layer graphicModel getDatas size equals: 1.
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testAddDShapeBeforeToBeVisible [

	| circle1 circle2 |

	"First create a circle when the layer is visible"
	self assert: layer isVisible.
	circle1 := (SmockDCircle key: #circle1) coordinates: 200@200; radius: 100; strokeColor: Color red; strokeWidth: 2; setDrawModeDevice.
	layer addDShape: circle1.
	self assert: layer graphicModel getDatas size equals: 1.
	
	"Hide the layer and add another circle"
	layer isVisible: false.
	circle2 := (SmockDCircle key: #circle2) coordinates: 100@100; radius: 100; strokeColor: Color yellow; strokeWidth: 2; setDrawModeDevice.
	layer addDShape: circle2.
	self assert: layer graphicModel getDatas size equals: 2.
	
	"Show the layer"
	layer isVisible: true.
	self assert: layer graphicModel getDatas size equals: 2.
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testAddDShapeBeforeToBeVisible2 [

	| circle2 |

	"Hide the layer and add a circle"
	layer isVisible: false.
	circle2 := (SmockDCircle key: #circle2) coordinates: 100@100; radius: 100; strokeColor: Color yellow; strokeWidth: 2; setDrawModeDevice.
	layer addDShape: circle2.
	self assert: layer graphicModel getDatas size equals: 1.
	
	"Show the layer"
	layer isVisible: true.
	self assert: layer graphicModel getDatas size equals: 1.
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testAddDShapes [

	| shape1 shape2 |
	shape1 := SmockDCircle key: 1.
	shape2 := SmockDCircle key: 2.
	layer addDShapes: (OrderedCollection with: shape1 with: shape2).
	
	self assert: layer displayModel size equals: 2.
	self assert: layer displayModel values first equals: shape1.
	self assert: layer graphicModel getDatas size equals: 2.
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testDisplayModel [

	self assert: layer displayModel isEmpty
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testHaveDomainObjects [

	self deny: layer haveDomainObjects
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testRemoveAllDShapes [

	| shape1 shape2 |
	shape1 := SmockDCircle key: 1.
	shape2 := SmockDCircle key: 2.
	layer
		addDShape: shape1;
		addDShape: shape2.

	layer removeAllDShapes.
	self assert: layer displayModel size equals: 0.
	self assert: layer graphicModel getDatas size equals: 0
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testRemoveDShape [

	| shape |
	shape := SmockDCircle key: 1.
	layer addDShape: shape.
	layer updateDShape: (shape
			 radius: 10;
			 yourself).
	layer removeDShape: shape.
	self assert: layer displayModel size equals: 0.
	self assert: layer graphicModel getDatas size equals: 0
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testRemoveDShapes [

	| shape1 shape2 |
	shape1 := SmockDCircle key: 1.
	shape2 := SmockDCircle key: 2.
	layer
		addDShape: shape1;
		addDShape: shape2.

	layer removeDShapes: (OrderedCollection with: shape1 with: shape2).
	self assert: layer displayModel size equals: 0.
	self assert: layer graphicModel getDatas size equals: 0
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testUpdateDShape [

	| shape |
	shape := SmockDCircle key: 1.
	layer addDShape: shape.
	layer updateDShape: (shape
			 radius: 10;
			 yourself).
	self assert: layer displayModel size equals: 1.
	self assert: layer displayModel values first equals: shape.
	self assert: layer graphicModel getDatas size equals: 1
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testUpdateDShapes [

	| shape1 shape2 |
	shape1 := SmockDCircle key: 1.
	shape2 := SmockDCircle key: 2.
	layer
		addDShape: shape1;
		addDShape: shape2.

	layer updateDShapes: (OrderedCollection with: shape1 with: shape2).
	self assert: layer displayModel size equals: 2.
	self assert: layer displayModel values first equals: shape1.
	self assert: layer graphicModel getDatas size equals: 2
]

{ #category : #tests }
GeoViewDShapesLayerTest >> testViewInfos [

	self assert: layer viewInfos isNil.
]
