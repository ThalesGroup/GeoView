Class {
	#name : #GeoViewPickedElement,
	#superclass : #SmockPickedElement,
	#instVars : [
		'geodesicDistanceInM'
	],
	#category : #'GeoView-Core'
}

{ #category : #accessing }
GeoViewPickedElement >> geodesicDistanceInM [

	^ geodesicDistanceInM
]

{ #category : #accessing }
GeoViewPickedElement >> geodesicDistanceInM: anObject [

	geodesicDistanceInM := anObject
]
