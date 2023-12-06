"
I am a Graphic Projection Model
"
Class {
	#name : #GeoViewModel,
	#superclass : #SmockDomainModel,
	#instVars : [
		'projection'
	],
	#category : #'GeoView-Model'
}

{ #category : #accessing }
GeoViewModel >> projection [

	^ projection
]

{ #category : #accessing }
GeoViewModel >> projection: aMapProjection [

	projection := aMapProjection
]
