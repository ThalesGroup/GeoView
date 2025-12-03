Class {
	#name : #GeoViewInteractionsStrategyTest,
	#superclass : #AbstractGeoViewInteractionsStrategyTest,
	#category : #'GeoView-Tests-Events'
}

{ #category : #running }
GeoViewInteractionsStrategyTest >> strategyClass [

	^ GeoViewInteractionsStrategy
]

{ #category : #tests }
GeoViewInteractionsStrategyTest >> testAllowMapMoving [

	super testAllowMapMoving.
	
	strategy isMapMoving: true.
	self assert: strategy isMapMoving.
	
	strategy allowMapMoving: false.
	self deny: strategy isMapMoving.
]
