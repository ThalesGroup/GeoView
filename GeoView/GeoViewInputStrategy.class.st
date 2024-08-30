Class {
	#name : #GeoViewInputStrategy,
	#superclass : #SmockInputStrategy,
	#category : #'GeoView-Core'
}

{ #category : #testing }
GeoViewInputStrategy class >> isAbstract [

	^ self = GeoViewInputStrategy
]

{ #category : #deprecation }
GeoViewInputStrategy class >> isDeprecated [
	^ true
]
