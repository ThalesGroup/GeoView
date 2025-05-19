Class {
	#name : #GeoViewCommand,
	#superclass : #Object,
	#category : #'GeoView-Core'
}

{ #category : #applying }
GeoViewCommand >> applyOn: aShapeContainer [

	self subclassResponsibility 
]
