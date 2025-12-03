"
An AbstractGeoViewInteractionsStrategyTest is a test class for testing the behavior of AbstractGeoViewInteractionsStrategy
"
Class {
	#name : #AbstractGeoViewInteractionsStrategyTest,
	#superclass : #TestCase,
	#instVars : [
		'strategy'
	],
	#category : #'GeoView-Tests-Events'
}

{ #category : #testing }
AbstractGeoViewInteractionsStrategyTest class >> isAbstract [ 

	^ self == AbstractGeoViewInteractionsStrategyTest 
]

{ #category : #running }
AbstractGeoViewInteractionsStrategyTest >> setUp [

	super setUp.

	strategy := self strategyClass new
]

{ #category : #running }
AbstractGeoViewInteractionsStrategyTest >> strategyClass [

	self subclassResponsibility 
]

{ #category : #tests }
AbstractGeoViewInteractionsStrategyTest >> testAllowMapMoving [

	self assert: strategy allowMapMoving.

	strategy allowMapMoving: false.
	self deny: strategy allowMapMoving.

	strategy allowMapMoving: true.
	self assert: strategy allowMapMoving
]

{ #category : #tests }
AbstractGeoViewInteractionsStrategyTest >> testAllowMapScaling [

	self assert: strategy allowMapScaling.

	strategy allowMapScaling: false.
	self deny: strategy allowMapScaling.

	strategy allowMapScaling: true.
	self assert: strategy allowMapScaling
]

{ #category : #tests }
AbstractGeoViewInteractionsStrategyTest >> testGeoView [

	| geoView |
	geoView := GeoViewElement new.

	self assert: strategy geoView isNil.

	strategy geoView: geoView.
	self assert: strategy geoView notNil.
	
	strategy geoView: nil.
	self assert: strategy geoView isNil.

]

{ #category : #tests }
AbstractGeoViewInteractionsStrategyTest >> testIsMultipleSelection [

	self assert: strategy isMultipleSelection.

	strategy isMultipleSelection: false.
	self deny: strategy isMultipleSelection.

	strategy isMultipleSelection: true.
	self assert: strategy isMultipleSelection
]

{ #category : #tests }
AbstractGeoViewInteractionsStrategyTest >> testPickingRadius [

	self assert: strategy pickingRadius equals: strategy class defaultPickingRadius.

	strategy pickingRadius: 10.
	self assert: strategy pickingRadius equals: 10.

	strategy pickingRadius: nil.
	self assert: strategy pickingRadius equals: strategy class defaultPickingRadius.
]

{ #category : #tests }
AbstractGeoViewInteractionsStrategyTest >> testSelectionFilterBlock [

	self assert: strategy selectionFilterBlock isNil.

	strategy selectionFilterBlock: [ :e | true ].
	self assert: strategy selectionFilterBlock notNil.

	strategy selectionFilterBlock: nil.
	self assert: strategy selectionFilterBlock isNil.
]
