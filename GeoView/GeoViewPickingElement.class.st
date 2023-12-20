Class {
	#name : #GeoViewPickingElement,
	#superclass : #SmockPickingElement,
	#instVars : [
		'geodesicDistanceInM'
	],
	#category : #'GeoView-Model'
}

{ #category : #accessing }
GeoViewPickingElement >> geoObject [

	self deprecated: 'use object'.
	^ self object
]

{ #category : #accessing }
GeoViewPickingElement >> geoObject: anObject [

	self deprecated: 'use object:'.
	self object: anObject
]

{ #category : #accessing }
GeoViewPickingElement >> geoObjectKey [

	self deprecated: 'use objectKey'.
	^ self objectKey
]

{ #category : #accessing }
GeoViewPickingElement >> geoObjectKey: anObject [

	self deprecated: 'use objectKey:'.
	self objectKey: anObject
]

{ #category : #accessing }
GeoViewPickingElement >> geodesicDistanceInM [

	^ geodesicDistanceInM
]

{ #category : #accessing }
GeoViewPickingElement >> geodesicDistanceInM: anObject [

	geodesicDistanceInM := anObject
]
