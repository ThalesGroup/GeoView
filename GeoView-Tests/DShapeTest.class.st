Class {
	#name : #DShapeTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - DShape'
}

{ #category : #tests }
DShapeTest >> testConstructor [ 
	
	| dShape |
	dShape := DShape key: #testDShape.
	
	self assert: dShape key equals: #testDShape.
]

{ #category : #tests }
DShapeTest >> testCopy [ 
	
	| dShape dShapeCopy |
	dShape := DShape new.
	dShapeCopy := dShape copy.
	
	self assert: dShapeCopy equals: dShape.
	self assert: (dShapeCopy == dShape) equals: false.
]

{ #category : #tests }
DShapeTest >> testInitialize [ 
	
	| dShape |
	dShape := DShape new.
	
	self assert: dShape key equals: nil.
	self assert: dShape coordinates equals: nil.
	self assert: dShape isVisible equals: true.
	self assert: dShape displayMask equals: nil.
	self assert: dShape displayOffset equals: nil.
	self assert: dShape isLeaf equals: false.
	self assert: dShape isComposite equals: false.
]
