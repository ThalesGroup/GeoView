Class {
	#name : #GeoViewMapProjectionChangedEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'projection'
	],
	#category : #'GeoView-Events'
}

{ #category : #accessing }
GeoViewMapProjectionChangedEvent >> projection [

	^ projection
]

{ #category : #accessing }
GeoViewMapProjectionChangedEvent >> projection: anObject [

	projection := anObject
]
