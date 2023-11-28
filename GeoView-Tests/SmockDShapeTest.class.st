Class {
	#name : #SmockDShapeTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - DShape'
}

{ #category : #tests }
SmockDShapeTest >> testConstructor [ 
	
	| dShape |
	dShape := SmockDShape key: #testDShape.
	
	self assert: dShape key equals: #testDShape.
]

{ #category : #tests }
SmockDShapeTest >> testCopy [ 
	
	| dShape dShapeCopy |
	dShape := SmockDShape new.
	dShapeCopy := dShape copy.
	
	self assert: dShapeCopy equals: dShape.
	self assert: (dShapeCopy == dShape) equals: false.
]

{ #category : #tests }
SmockDShapeTest >> testInitialize [ 
	
	| dShape |
	dShape := SmockDShape new.
	
	self assert: dShape key equals: nil.
	self assert: dShape coordinates equals: nil.
	self assert: dShape isVisible equals: true.
	self assert: dShape displayMask equals: nil.
	self assert: dShape displayOffset equals: nil.
	self assert: dShape isLeaf equals: false.
	self assert: dShape isComposite equals: false.
]
