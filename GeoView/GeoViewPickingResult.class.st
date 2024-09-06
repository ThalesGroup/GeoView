Class {
	#name : #GeoViewPickingResult,
	#superclass : #SmockPickingResult,
	#instVars : [
		'cartesianCoordinates',
		'absoluteCoordinates',
		'distanceBlock'
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
GeoViewPickingResult >> distanceBlock [

	^ distanceBlock
]

{ #category : #accessing }
GeoViewPickingResult >> distanceBlock: anObject [

	distanceBlock := anObject
]

{ #category : #accessing }
GeoViewPickingResult >> printString [

	| ws string |
	string := super printString.
	ws := WriteStream on: String new.
	ws nextPutAll: string.

	ws space.
	ws nextPutAll: self absoluteCoordinates printString.
	
	^ ws contents
]
