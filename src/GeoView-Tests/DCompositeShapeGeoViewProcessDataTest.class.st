"
A DCompositeShapeGeoViewAeProcessDataTest is a test class for testing the behavior of DCompositeShapeGeoViewAeProcessData
"
Class {
	#name : #DCompositeShapeGeoViewProcessDataTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - ProcessDatas'
}

{ #category : #tests }
DCompositeShapeGeoViewProcessDataTest >> testProcessCreatedDataIncomingWithContext [

	| processData dShape gShape |
	processData := DCompositeShapeGeoViewProcessData new.
	dShape := SmockDCompositeShape new.
	gShape := processData processCreatedData: #test incoming: dShape with: nil context: nil.
	
	self assert: gShape class equals: SmockGCompositeShape2D.
	self assert: gShape id equals: #test.
	self assert: gShape isVisible.
]

{ #category : #tests }
DCompositeShapeGeoViewProcessDataTest >> testProcessUpdatedDataIncomingWithContext [

	| processData dShape gShape |
	processData := DCompositeShapeGeoViewProcessData new.
	dShape := SmockDCompositeShape new.
	gShape := processData processCreatedData: #test incoming: dShape with: nil context: nil.
	
	dShape isVisible: false.
	gShape := processData processCreatedData: #test incoming: dShape with: gShape context: nil.
	
	self assert: gShape class equals: SmockGCompositeShape2D.
	self assert: gShape id equals: #test.
	self deny: gShape isVisible.
]
