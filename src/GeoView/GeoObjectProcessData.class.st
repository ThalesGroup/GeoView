"
Processdata hierarchy to process GeoObjects class hierarchy (GeoCircle, GeoEllipse, etc.)
"
Class {
	#name : #GeoObjectProcessData,
	#superclass : #GeoViewDomainProcessData,
	#instVars : [
		'displayFilterBlock'
	],
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #accessing }
GeoObjectProcessData class >> isAbstract [ 

	^ self == GeoObjectProcessData 
]

{ #category : #computing }
GeoObjectProcessData >> computeDisplayFilter: aKey incoming: aTObject with: aDShape context: aContext [

	"propose a block to setup the filter externally"
	self displayFilterBlock ifNotNil:[ :b | b cull: aKey cull: aTObject cull: aDShape cull: aContext ].

	^ aDShape
]

{ #category : #computing }
GeoObjectProcessData >> computePosition: aKey incoming: aGeoObject with: aDShape context: aContext [

	| coordinates absoluteCoordinates |
	absoluteCoordinates := aGeoObject absoluteCoordinates.
	absoluteCoordinates
		ifNotNil: [
			absoluteCoordinates isEmpty ifTrue: [
				absoluteCoordinates := AbsoluteCoordinates zero ] ]
		ifNil: [ absoluteCoordinates := AbsoluteCoordinates zero ].

	absoluteCoordinates isEmpty ifTrue: [
		absoluteCoordinates := AbsoluteCoordinates zero ].
	coordinates := self processor projection projLatLonToCart:
		               absoluteCoordinates.

	aDShape coordinates: coordinates.
	^ aDShape
]

{ #category : #computing }
GeoObjectProcessData >> displayFilterBlock [

	self flag:'labordep: for examples, dirty, need to be reworked'.
	^ displayFilterBlock
]

{ #category : #computing }
GeoObjectProcessData >> displayFilterBlock: anObject [

	self flag:'labordep: for examples, dirty, need to be reworked'.
	displayFilterBlock := anObject
]

{ #category : #processing }
GeoObjectProcessData >> processCreatedData: aKey incoming: aGeoObject with: aDShape context: aContext [
	| dShape |
	dShape := aDShape.
	self assert: [dShape notNil] description: ['[ProcessGeoObject] DShape can not be nil because this process data cannot be used singulary.' ].
	
	dShape key: aGeoObject key.
	dShape isVisible: aGeoObject isVisible.
	self computePosition: aKey incoming: aGeoObject with: aDShape context: aContext.
	self computeDisplayFilter: aKey incoming: aGeoObject with: aDShape context: aContext.
	
	^ dShape
]

{ #category : #processing }
GeoObjectProcessData >> processDeletedData: aKey incoming: aGeoObject with: aDShape context: aContext [

	^ aDShape
]

{ #category : #processing }
GeoObjectProcessData >> processRecycledData: aKey incoming: aGeoObject with: aDShape context: aContext [
	
	aDShape key: nil.
	aDShape removeProperties.
	aDShape coordinates: nil.
	aDShape coordinatesDeviceOffset: nil.
	aDShape displayFilter: nil.
	aDShape drawMode: nil.
	aDShape isVisible: nil.
	aDShape isTranslatedByParent: nil.
	aDShape zIndex: nil.
	
	aDShape isComposite ifTrue:[ 
		aDShape dShapeList removeAll.
		aDShape toUpdateDShapeList removeAll.
		aDShape toDeleteDShapeList removeAll.
		aDShape hasUserComputingChildren: nil.
	].

	^ aDShape
]

{ #category : #processing }
GeoObjectProcessData >> processStateChanged: aKey state: aState value: aValueOrNil with: aDShape context: aContext [

	^ aDShape
]

{ #category : #processing }
GeoObjectProcessData >> processUpdatedData: aKey incoming: aGeoObject with: aDShape context: aContext [

	aDShape isVisible: aGeoObject isVisible.
	self computePosition: aKey incoming: aGeoObject with: aDShape context: aContext.
	self computeDisplayFilter: aKey incoming: aGeoObject with: aDShape context: aContext.

	^ aDShape
]
