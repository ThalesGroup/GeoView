Class {
	#name : #GeoProjectionModelTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - Model'
}

{ #category : #tests }
GeoProjectionModelTest >> testInitialize [
	| model |
	model := GeoViewModel new.
	self assert: model projection isNil.
]
