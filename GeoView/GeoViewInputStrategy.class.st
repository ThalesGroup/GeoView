Class {
	#name : #GeoViewInputStrategy,
	#superclass : #SmockInputStrategy,
	#category : #'GeoView-Deprecated'
}

{ #category : #testing }
GeoViewInputStrategy class >> isAbstract [

	^ self = GeoViewInputStrategy
]

{ #category : #deprecation }
GeoViewInputStrategy class >> isDeprecated [
	^ true
]
