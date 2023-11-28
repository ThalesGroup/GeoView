Class {
	#name : #SmockDLeafShapeTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - DShape'
}

{ #category : #tests }
SmockDLeafShapeTest >> testCopy [ 
	
	| dShape dShapeCopy |
	dShape := SmockDLeafShape new.
	dShapeCopy := dShape copy.
	
	self assert: dShapeCopy equals: dShape.
	self assert: (dShapeCopy == dShape) equals: false.
]

{ #category : #tests }
SmockDLeafShapeTest >> testDrawMode [ 
	
	| dShape |
	dShape := SmockDLeafShape new.

	dShape setDrawModeUser.
	self assert: dShape isDrawModeUser equals: true.
	self assert: dShape isDrawModeDevice equals: false.
	
	dShape setDrawModeDevice.
	self assert: dShape isDrawModeUser equals: false.
	self assert: dShape isDrawModeDevice equals: true.
	
	dShape drawMode: nil.
	self assert: dShape drawMode equals: #device.
	self assert: dShape isDrawModeUser equals: false.
	self assert: dShape isDrawModeDevice equals: true.
	
	dShape drawMode: #anotherMode.
	self assert: dShape drawMode equals: #anotherMode.
	self assert: dShape isDrawModeUser equals: false.
	self assert: dShape isDrawModeDevice equals: false.
]

{ #category : #tests }
SmockDLeafShapeTest >> testInitialize [ 
	
	| dShape |
	dShape := SmockDLeafShape new.
	
	self assert: dShape isLeaf equals: true.
	self assert: dShape isComposite equals: false.
	self assert: dShape drawMode equals: #device.
	self assert: dShape isDrawModeDevice equals: true.
	self assert: dShape isDrawModeUser equals: false.
	self assert: dShape fillColor equals: nil.
	self assert: dShape strokeColor equals: nil.
	self assert: dShape strokeWidth equals: nil.
	self assert: dShape strokePattern equals: nil.
]
