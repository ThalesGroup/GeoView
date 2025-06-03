Class {
	#name : #GeoViewDisplayFilter,
	#superclass : #Object,
	#instVars : [
		'allowedAttributes'
	],
	#category : #'GeoView-Core'
}

{ #category : #'instance creation' }
GeoViewDisplayFilter class >> isAbstract [

	^ self = GeoViewDisplayFilter 
]

{ #category : #testing }
GeoViewDisplayFilter >> isEmpty [

	^ true
]

{ #category : #testing }
GeoViewDisplayFilter >> isFilteringNothing [

	^ self isEmpty 
]
