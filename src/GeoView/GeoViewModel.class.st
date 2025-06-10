"
I am a Graphic Projection Model
"
Class {
	#name : #GeoViewModel,
	#superclass : #SmockDomainModel,
	#instVars : [
		'projection',
		'displayFilter'
	],
	#category : #'GeoView-Core'
}

{ #category : #accessing }
GeoViewModel >> displayFilter [

	^ displayFilter
]

{ #category : #accessing }
GeoViewModel >> displayFilter: anObject [

	displayFilter := anObject
]

{ #category : #accessing }
GeoViewModel >> projection [

	^ projection
]

{ #category : #accessing }
GeoViewModel >> projection: aProjection [

	projection := aProjection
]
