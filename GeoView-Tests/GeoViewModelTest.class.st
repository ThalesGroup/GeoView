Class {
	#name : #GeoViewModelTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - Core'
}

{ #category : #tests }
GeoViewModelTest >> testInitialize [
	| model |
	model := GeoViewModel new.
	self assert: model projection isNil.
]
