"
I am a Graphic Projection Model
"
Class {
	#name : #GeoViewCUDModel,
	#superclass : #SmockCUDModel,
	#instVars : [
		'projection'
	],
	#category : #'GeoView-Model'
}

{ #category : #accessing }
GeoViewCUDModel >> projection [

	^ projection
]

{ #category : #accessing }
GeoViewCUDModel >> projection: aMapProjection [

	projection := aMapProjection
]
