Class {
	#name : #DCompositeShapeTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - DShape'
}

{ #category : #tests }
DCompositeShapeTest >> testAddUpdateAndDeleteChildren [ 
	
	| dCompositeShape dLeafShape |
	dCompositeShape := DCompositeShape new.
	dLeafShape := DLeafShape key: #testLeafShape. 
	
	dCompositeShape addDShape: dLeafShape.
	self assert: dCompositeShape dShapeList size equals: 1.
	self assert: dCompositeShape dShapeList first identicalTo: dLeafShape.
	self assert: dCompositeShape toUpdateDShapeList isEmpty.
	self assert: dCompositeShape toDeleteDShapeList isEmpty.

	dCompositeShape updateDShape: dLeafShape.
	self assert: dCompositeShape dShapeList size equals: 1.
	self assert: dCompositeShape dShapeList first identicalTo: dLeafShape.
	self assert: dCompositeShape toUpdateDShapeList size equals: 1.
	self assert: dCompositeShape toUpdateDShapeList first identicalTo: dLeafShape.
	self assert: dCompositeShape toDeleteDShapeList isEmpty.

	dCompositeShape clearToUpdateDShapeList.	
	self assert: dCompositeShape dShapeList size equals: 1.
	self assert: dCompositeShape dShapeList first identicalTo: dLeafShape.
	self assert: dCompositeShape toUpdateDShapeList isEmpty.
	self assert: dCompositeShape toDeleteDShapeList isEmpty.
	
	dCompositeShape deleteDShape: dLeafShape.
	self assert: dCompositeShape dShapeList size equals: 1.
	self assert: dCompositeShape dShapeList first identicalTo: dLeafShape.
	self assert: dCompositeShape toDeleteDShapeList size equals: 1.
	self assert: dCompositeShape toDeleteDShapeList first identicalTo: dLeafShape.
	
	dCompositeShape dShapeList removeAll.
	dCompositeShape clearToDeleteDShapeList.
	self assert: dCompositeShape dShapeList size equals: 0.
	self assert: dCompositeShape toDeleteDShapeList size equals: 0.
]

{ #category : #tests }
DCompositeShapeTest >> testCopy [ 
	
	| dShape dShapeCopy |
	dShape := DCompositeShape new.
	dShapeCopy := dShape copy.
	
	self assert: dShapeCopy equals: dShape.
	self assert: (dShapeCopy == dShape) equals: false. 
]

{ #category : #tests }
DCompositeShapeTest >> testGetChildren [ 
	
	| dCompositeShape dLeafShape dLeafShape2 |
	dCompositeShape := DCompositeShape new.
	dLeafShape := DLeafShape key: #testLeafShape. 
	dLeafShape2 := DLeafShape key: #testLeafShape2. 
	
	self assert: (dCompositeShape getDShape: nil) equals: nil. 
	self assert: (dCompositeShape getDShape: #notExistingKey) equals: nil. 
	
	dCompositeShape addDShape: dLeafShape.
	self assert: (dCompositeShape getDShape: nil) equals: nil. 
	self assert: (dCompositeShape getDShape: #notExistingKey) equals: nil. 
	self assert: (dCompositeShape getDShape: #testLeafShape) identicalTo: dLeafShape. 
	
	dCompositeShape addDShape: dLeafShape2.
	self assert: (dCompositeShape getDShape: nil) equals: nil. 
	self assert: (dCompositeShape getDShape: #notExistingKey) equals: nil. 
	self assert: (dCompositeShape getDShape: #testLeafShape) identicalTo: dLeafShape. 
	self assert: (dCompositeShape getDShape: #testLeafShape2) identicalTo: dLeafShape2. 
]

{ #category : #tests }
DCompositeShapeTest >> testInitialize [ 
	
	| dShape |
	dShape := DCompositeShape new.
	
	self assert: dShape isLeaf equals: false.
	self assert: dShape isComposite equals: true.
	self assert: dShape hasUserDrawModeDShape equals: false.
	self assert: dShape dShapeList isEmpty.
	self assert: dShape toUpdateDShapeList isEmpty.
	self assert: dShape toDeleteDShapeList isEmpty.
]
