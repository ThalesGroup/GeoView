Class {
	#name : #GeoViewCursorCoordinatesChangedEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'absoluteCoordinates'
	],
	#category : #'GeoView-Bloc-Events'
}

{ #category : #accessing }
GeoViewCursorCoordinatesChangedEvent >> absoluteCoordinates [

	^ absoluteCoordinates
]

{ #category : #accessing }
GeoViewCursorCoordinatesChangedEvent >> absoluteCoordinates: anObject [

	absoluteCoordinates := anObject
]

{ #category : #sending }
GeoViewCursorCoordinatesChangedEvent >> sendTo: anObject [

	anObject geoViewCursorCoordinatesChangedEvent: self
]
