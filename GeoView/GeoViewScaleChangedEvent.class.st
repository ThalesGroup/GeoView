Class {
	#name : #GeoViewScaleChangedEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'scaleInMeters'
	],
	#category : #'GeoView-Events'
}

{ #category : #accessing }
GeoViewScaleChangedEvent >> scaleInMeters [

	^ scaleInMeters
]

{ #category : #accessing }
GeoViewScaleChangedEvent >> scaleInMeters: anObject [

	scaleInMeters := anObject
]

{ #category : #sending }
GeoViewScaleChangedEvent >> sendTo: anObject [

	anObject geoViewScaleChangedEvent: self
]
