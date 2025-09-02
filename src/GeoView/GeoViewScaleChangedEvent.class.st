Class {
	#name : #GeoViewScaleChangedEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'scale'
	],
	#category : #'GeoView-Events'
}

{ #category : #accessing }
GeoViewScaleChangedEvent >> scale [

	^ scale
]

{ #category : #accessing }
GeoViewScaleChangedEvent >> scale: aNumber [

	scale := aNumber
]

{ #category : #accessing }
GeoViewScaleChangedEvent >> scaleInMeters [

	self 
		deprecated:'Use generic message' 
		transformWith: '`@receiver scaleInMeters' -> '`@receiver scale'.

	^ self scale
]

{ #category : #accessing }
GeoViewScaleChangedEvent >> scaleInMeters: aNumber [

	self 
		deprecated:'Use generic message' 
		transformWith: '`@receiver scaleInMeters: `@aNumber' -> '`@receiver scale: `@aNumber'.

	self scale: aNumber
]

{ #category : #sending }
GeoViewScaleChangedEvent >> sendTo: anObject [

	anObject geoViewScaleChangedEvent: self
]
