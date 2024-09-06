Class {
	#name : #AbstractGeoViewLayer,
	#superclass : #Object,
	#instVars : [
		'isVisible',
		'processDataChangedBlock',
		'name',
		'announcer'
	],
	#category : #'GeoView-Core'
}

{ #category : #testing }
AbstractGeoViewLayer class >> isAbstract [ 

	^ self == AbstractGeoViewLayer 
]

{ #category : #accessing }
AbstractGeoViewLayer >> announcer [

	^ announcer ifNil:[ announcer := Announcer new ]
]

{ #category : #'API -- projection' }
AbstractGeoViewLayer >> graphicProjection [

	self explicitRequirement
]

{ #category : #'API -- projection' }
AbstractGeoViewLayer >> graphicProjection: aGraphicProjection [

	self explicitRequirement
]

{ #category : #testing }
AbstractGeoViewLayer >> haveGeoObjects [

	^ false
]

{ #category : #'API -- drawing' }
AbstractGeoViewLayer >> isVisible [

	^ isVisible ifNil:[ isVisible := true ]
]

{ #category : #'API -- drawing' }
AbstractGeoViewLayer >> isVisible: aBoolean [

	isVisible := false
]

{ #category : #'API -- projection' }
AbstractGeoViewLayer >> mapProjection [

	self explicitRequirement
]

{ #category : #'API -- projection' }
AbstractGeoViewLayer >> mapProjection: aMapProjection [

	self explicitRequirement
]

{ #category : #accessing }
AbstractGeoViewLayer >> name [

	^ name
]

{ #category : #accessing }
AbstractGeoViewLayer >> name: anObject [

	name := anObject
]

{ #category : #'API -- picking' }
AbstractGeoViewLayer >> populatePickingResult: aPickingResult [ 

	self explicitRequirement 
]

{ #category : #'API -- symbology' }
AbstractGeoViewLayer >> symbologyProvider: aSymbologyProvider [

	self explicitRequirement
]

{ #category : #'API -- drawing' }
AbstractGeoViewLayer >> updateGraphicModel [

	self explicitRequirement
]
