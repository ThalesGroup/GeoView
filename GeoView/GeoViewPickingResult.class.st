Class {
	#name : #GeoViewPickingResult,
	#superclass : #SmockPickingResult,
	#instVars : [
		'cartesianCoordinates',
		'absoluteCoordinates'
	],
	#category : #'GeoView-Core'
}

{ #category : #accessing }
GeoViewPickingResult >> absoluteCoordinates [
	^ absoluteCoordinates
]

{ #category : #accessing }
GeoViewPickingResult >> absoluteCoordinates: anObject [
	absoluteCoordinates := anObject
]

{ #category : #accessing }
GeoViewPickingResult >> cartesianCoordinates [
	^ cartesianCoordinates
]

{ #category : #accessing }
GeoViewPickingResult >> cartesianCoordinates: anObject [
	cartesianCoordinates := anObject
]

{ #category : #accessing }
GeoViewPickingResult >> getGeoObjectKeys [

	self deprecated: 'use objectkeys'.
	^ self getObjectKeys 
]

{ #category : #accessing }
GeoViewPickingResult >> getGeoObjects [

	self deprecated: 'use objects'.
	^ self getObjects
]
