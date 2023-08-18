Class {
	#name : #GeoViewEventBehavior,
	#superclass : #Object,
	#instVars : [
		'geoViewManager'
	],
	#category : #'GeoView-Model'
}

{ #category : #accessing }
GeoViewEventBehavior >> geoViewManager [
	^ geoViewManager
]

{ #category : #accessing }
GeoViewEventBehavior >> geoViewManager: anObject [
	geoViewManager := anObject
]

{ #category : #'event handling' }
GeoViewEventBehavior >> receiveEvent: aPenEvent [
	self explicitRequirement.
]
