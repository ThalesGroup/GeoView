Class {
	#name : #GeoViewTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - Core'
}

{ #category : #tests }
GeoViewTest >> testBaselineOfBlocCommandLoading [
	"test if the required package 'Bloc-CommandApplier' is loaded"
	
	self assert: (Smalltalk classNamed: #BlCommandApplicationTask) notNil
]
