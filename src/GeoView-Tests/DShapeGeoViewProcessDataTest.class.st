"
A DShapeGeoViewProcessDataTest is a test class for testing the behavior of DShapeGeoViewProcessData
"
Class {
	#name : #DShapeGeoViewProcessDataTest,
	#superclass : #TestCase,
	#instVars : [
		'processData',
		'context',
		'dShapes'
	],
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #testing }
DShapeGeoViewProcessDataTest class >> isAbstract [ 

	^ self == DShapeGeoViewProcessDataTest 
]

{ #category : #asserting }
DShapeGeoViewProcessDataTest >> assertCreatedGShape: aGShape forDShape: aDShape iteration: aNumber [

	self assert: (aGShape isKindOf: SmockGShape2D).
	self assert: aDShape hasEffect equals: aGShape hasEffect.
]

{ #category : #asserting }
DShapeGeoViewProcessDataTest >> assertDeletedGShape: aGShape forDShape: aDShape iteration: aNumber [

	self assert: (aGShape isKindOf: SmockGShape2D).
	self assert: aDShape hasEffect equals: aGShape hasEffect.
]

{ #category : #asserting }
DShapeGeoViewProcessDataTest >> assertGShapeStateChanged: aGShape iteration: aNumber [

	self assert: (aGShape isKindOf: SmockGShape2D)
]

{ #category : #asserting }
DShapeGeoViewProcessDataTest >> assertRecycledGShape: aGShape forDShape: aDShape iteration: aNumber [

	self assert: (aGShape isKindOf: SmockGShape2D).
	self deny: aGShape hasEffect.
]

{ #category : #asserting }
DShapeGeoViewProcessDataTest >> assertUpdatedGShape: aGShape forDShape: aDShape iteration: aNumber [

	self assert: (aGShape isKindOf: SmockGShape2D).
	self assert: aDShape hasEffect equals: aGShape hasEffect.
]

{ #category : #running }
DShapeGeoViewProcessDataTest >> createContext [

	^ nil
]

{ #category : #running }
DShapeGeoViewProcessDataTest >> createDShapes [
	"Create a list of DShape to execute several tests"

	^ self subclassResponsibility 
]

{ #category : #running }
DShapeGeoViewProcessDataTest >> processDataClass [ 

	^ self subclassResponsibility 
]

{ #category : #running }
DShapeGeoViewProcessDataTest >> setUp [

	super setUp.

	processData := self processDataClass new.
	self setUpProcessData.

	dShapes := self createDShapes.
	context := self createContext.
]

{ #category : #running }
DShapeGeoViewProcessDataTest >> setUpProcessData [

	processData processor: GeoViewModel new.
	processData processor projection: GeoView2DProjection new.
]

{ #category : #tests }
DShapeGeoViewProcessDataTest >> testProcessCreatedDataIncomingWithContext [

	| i |
	i := 1.
	
	dShapes do:[ :dShape | | gShape |
		gShape := processData processCreatedData: 1 incoming: dShape with: nil context: context.
		self assertCreatedGShape: gShape forDShape: dShape iteration: i.
		i := i +1.
	].

	self assert: i > 1
]

{ #category : #tests }
DShapeGeoViewProcessDataTest >> testProcessDeletedDataIncomingWithContext [

	| i |
	i := 1.
	
	dShapes do:[ :dShape | | gShape |
		gShape := processData processCreatedData: 1 incoming: dShape with: nil context: context.
		gShape := processData processDeletedData: 1 incoming: dShape with: gShape context: context.
		self assertDeletedGShape: gShape forDShape: dShape iteration: i.
		i := i +1.
	].

	self assert: i > 1
]

{ #category : #tests }
DShapeGeoViewProcessDataTest >> testProcessRecycledDataIncomingWithContext [

	| i |
	i := 1.
	
	dShapes do:[ :dShape | | gShape |
		gShape := processData processCreatedData: 1 incoming: dShape with: nil context: context.
		gShape := processData processDeletedData: 1 incoming: dShape with: gShape context: context.
		gShape := processData processRecycledData: 1 incoming: dShape with: gShape context: context.
		self assertRecycledGShape: gShape forDShape: dShape iteration: i.
		i := i +1.
	].

	self assert: i > 1
]

{ #category : #tests }
DShapeGeoViewProcessDataTest >> testProcessStateChangedStateValueWithContext [

	| i |
	i := 1.
	
	dShapes do:[ :dShape | | gShape |
		gShape := processData processCreatedData: 1 incoming: dShape with: nil context: context.
		gShape := processData processStateChanged: 1 state: #testState value: true with: gShape context: context.
		self assertGShapeStateChanged: gShape iteration: i.
		i := i +1.
	].

	self assert: i > 1
]

{ #category : #tests }
DShapeGeoViewProcessDataTest >> testProcessUpdatedDataIncomingWithContext [

	| i |
	i := 1.
	
	dShapes do:[ :dShape | | gShape |
		gShape := processData processCreatedData: 1 incoming: dShape with: nil context: context.
		gShape := processData processUpdatedData: 1 incoming: dShape with: gShape context: context.
		self assertUpdatedGShape: gShape forDShape: dShape iteration: i.
		i := i +1.
	].

	self assert: i > 1
]
