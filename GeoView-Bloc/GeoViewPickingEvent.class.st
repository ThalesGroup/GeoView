Class {
	#name : #GeoViewPickingEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'pickingResult'
	],
	#category : #'GeoView-Bloc-Events'
}

{ #category : #accessing }
GeoViewPickingEvent >> pickingResult [

	^ pickingResult
]

{ #category : #accessing }
GeoViewPickingEvent >> pickingResult: anObject [

	pickingResult := anObject
]

{ #category : #sending }
GeoViewPickingEvent >> sendTo: anObject [

	anObject geoViewPickingEvent: self
]
