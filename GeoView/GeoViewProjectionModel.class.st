"
I am a Graphic Projection Model
"
Class {
	#name : #GeoViewProjectionModel,
	#superclass : #GeoViewModel,
	#instVars : [
		'projection'
	],
	#category : #'GeoView-Model'
}

{ #category : #accessing }
GeoViewProjectionModel >> projection [
	^ projection
]

{ #category : #accessing }
GeoViewProjectionModel >> projection: aMapProjection [ 
	projection := aMapProjection
]
