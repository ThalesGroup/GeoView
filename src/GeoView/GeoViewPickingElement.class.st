Class {
	#name : #GeoViewPickingElement,
	#superclass : #SmockPickingElement,
	#instVars : [
		'geodesicDistanceInM'
	],
	#category : #'GeoView-Core'
}

{ #category : #accessing }
GeoViewPickingElement >> geodesicDistanceInM [

	^ geodesicDistanceInM
]

{ #category : #accessing }
GeoViewPickingElement >> geodesicDistanceInM: anObject [

	geodesicDistanceInM := anObject
]
