Class {
	#name : #GeoViewCenterChangedEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'absoluteCoordinates'
	],
	#category : #'GeoView-Bloc-Events'
}

{ #category : #accessing }
GeoViewCenterChangedEvent >> absoluteCoordinates [

	^ absoluteCoordinates
]

{ #category : #accessing }
GeoViewCenterChangedEvent >> absoluteCoordinates: anObject [

	absoluteCoordinates := anObject
]

{ #category : #sending }
GeoViewCenterChangedEvent >> sendTo: anObject [

	anObject geoViewCenterChangedEvent: self
]
