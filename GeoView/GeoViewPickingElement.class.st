Class {
	#name : #GeoViewPickingElement,
	#superclass : #Object,
	#instVars : [
		'layerLevel',
		'layerName',
		'distanceInPixels',
		'geodesicDistanceInM',
		'geoObjectKey',
		'geoObject',
		'dShape',
		'gShape'
	],
	#category : #'GeoView-Picking'
}

{ #category : #accessing }
GeoViewPickingElement >> dShape [
	^ dShape
]

{ #category : #accessing }
GeoViewPickingElement >> dShape: anObject [
	dShape := anObject
]

{ #category : #accessing }
GeoViewPickingElement >> distanceInPixels [
	^ distanceInPixels
]

{ #category : #accessing }
GeoViewPickingElement >> distanceInPixels: anObject [
	distanceInPixels := anObject
]

{ #category : #accessing }
GeoViewPickingElement >> gShape [
	^ gShape
]

{ #category : #accessing }
GeoViewPickingElement >> gShape: anObject [
	gShape := anObject
]

{ #category : #accessing }
GeoViewPickingElement >> geoObject [
	^ geoObject
]

{ #category : #accessing }
GeoViewPickingElement >> geoObject: anObject [
	geoObject := anObject
]

{ #category : #accessing }
GeoViewPickingElement >> geoObjectKey [
	^ geoObjectKey
]

{ #category : #accessing }
GeoViewPickingElement >> geoObjectKey: anObject [
	geoObjectKey := anObject
]

{ #category : #accessing }
GeoViewPickingElement >> geodesicDistanceInM [
	^ geodesicDistanceInM
]

{ #category : #accessing }
GeoViewPickingElement >> geodesicDistanceInM: anObject [
	geodesicDistanceInM := anObject
]

{ #category : #accessing }
GeoViewPickingElement >> layerLevel [
	^ layerLevel
]

{ #category : #accessing }
GeoViewPickingElement >> layerLevel: anObject [
	layerLevel := anObject
]

{ #category : #accessing }
GeoViewPickingElement >> layerName [
	^ layerName
]

{ #category : #accessing }
GeoViewPickingElement >> layerName: anObject [
	layerName := anObject
]
