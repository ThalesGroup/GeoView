Class {
	#name : #DLeafShapeTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - DShape'
}

{ #category : #tests }
DLeafShapeTest >> testCopy [ 
	
	| dShape dShapeCopy |
	dShape := DLeafShape new.
	dShapeCopy := dShape copy.
	
	self assert: dShapeCopy equals: dShape.
	self assert: (dShapeCopy == dShape) equals: false.
]

{ #category : #tests }
DLeafShapeTest >> testDrawMode [ 
	
	| dShape |
	dShape := DLeafShape new.

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
DLeafShapeTest >> testInitialize [ 
	
	| dShape |
	dShape := DLeafShape new.
	
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
