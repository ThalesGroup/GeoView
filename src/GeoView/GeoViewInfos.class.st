Class {
	#name : #GeoViewInfos,
	#superclass : #Object,
	#instVars : [
		'origin',
		'extent'
	],
	#category : #'GeoView-Core'
}

{ #category : #accessing }
GeoViewInfos >> bounds [

	^ 0@0 extent: self extent 
]

{ #category : #accessing }
GeoViewInfos >> center [

	^ self extent / 2
]

{ #category : #accessing }
GeoViewInfos >> extent [

	^ extent ifNil:[ extent := 0@0 ]
]

{ #category : #accessing }
GeoViewInfos >> extent: aPoint [

	extent := aPoint
]

{ #category : #accessing }
GeoViewInfos >> height [

	^ self extent y
]

{ #category : #accessing }
GeoViewInfos >> origin [

	^ origin ifNil:[ origin := 0@0 ]
]

{ #category : #accessing }
GeoViewInfos >> origin: anObject [

	origin := anObject
]

{ #category : #updating }
GeoViewInfos >> update [
	"do some computing here"

	
]

{ #category : #accessing }
GeoViewInfos >> width [

	^ self extent x
]
