Class {
	#name : #GeoViewPickingResult,
	#superclass : #Object,
	#instVars : [
		'localPoint',
		'globalPoint',
		'cartesianCoordinates',
		'absoluteCoordinates',
		'results',
		'date',
		'time',
		'radiusInPixels'
	],
	#category : #'GeoView-Picking'
}

{ #category : #defaults }
GeoViewPickingResult class >> defaultDObjectDistanceBlock [
	self flag:'PLa : cest un parametrage a mettre dans les strategy ou les ProcessDatas'.
	^ [ :dObject :point | dObject distanceTo: point ]
]

{ #category : #accessing }
GeoViewPickingResult >> absoluteCoordinates [
	^ absoluteCoordinates
]

{ #category : #accessing }
GeoViewPickingResult >> absoluteCoordinates: anObject [
	absoluteCoordinates := anObject
]

{ #category : #accessing }
GeoViewPickingResult >> addPickingElement: aPickingElement [
	self results add: aPickingElement
]

{ #category : #API }
GeoViewPickingResult >> applyFilter: aBlock [
	"apply a filter on the result list"

	| _results |
	_results := self results copy select:[ :e | aBlock value: e].
	self results: _results.
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
GeoViewPickingResult >> date [
	^ date
]

{ #category : #accessing }
GeoViewPickingResult >> date: anObject [
	date := anObject
]

{ #category : #accessing }
GeoViewPickingResult >> getGeoObjectKeys [

	^self results collect:[ :e | e geoObjectKey ].
]

{ #category : #accessing }
GeoViewPickingResult >> getGeoObjects [

	^self results collect:[ :e | e geoObject ].
]

{ #category : #accessing }
GeoViewPickingResult >> globalPoint [
	^ globalPoint
]

{ #category : #accessing }
GeoViewPickingResult >> globalPoint: anObject [
	globalPoint := anObject
]

{ #category : #testing }
GeoViewPickingResult >> hasJustOneElement [

	^self results size = 1
]

{ #category : #testing }
GeoViewPickingResult >> hasMoreElements [

	^self results size > 1
]

{ #category : #testing }
GeoViewPickingResult >> isEmpty [

	^self results isEmpty
]

{ #category : #accessing }
GeoViewPickingResult >> localPoint [
	^ localPoint
]

{ #category : #accessing }
GeoViewPickingResult >> localPoint: anObject [
	localPoint := anObject
]

{ #category : #testing }
GeoViewPickingResult >> notEmpty [

	^self results notEmpty
]

{ #category : #accessing }
GeoViewPickingResult >> radiusInPixels [
	^ radiusInPixels
]

{ #category : #accessing }
GeoViewPickingResult >> radiusInPixels: anObject [
	radiusInPixels := anObject
]

{ #category : #accessing }
GeoViewPickingResult >> removePickingElement: aPickingElement [
	self results remove: aPickingElement
]

{ #category : #accessing }
GeoViewPickingResult >> results [
	^ results ifNil: [ results := OrderedCollection new ]
]

{ #category : #accessing }
GeoViewPickingResult >> results: anObject [
	results := anObject
]

{ #category : #accessing }
GeoViewPickingResult >> time [
	^ time
]

{ #category : #accessing }
GeoViewPickingResult >> time: anObject [
	time := anObject
]
