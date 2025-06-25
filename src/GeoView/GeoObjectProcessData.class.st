"
Processdata hierarchy to process GeoObjects class hierarchy (GeoCircle, GeoEllipse, etc.)
"
Class {
	#name : #GeoObjectProcessData,
	#superclass : #GeoBusinessObjectProcessData,
	#instVars : [
		'displayFilterBlock'
	],
	#category : #'GeoView-Business - GeoObjects'
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

	^ displayFilterBlock
]

{ #category : #computing }
GeoObjectProcessData >> displayFilterBlock: anObject [

	displayFilterBlock := anObject
]

{ #category : #computing }
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

{ #category : #computing }
GeoObjectProcessData >> processDeletedData: aKey incoming: aGeoObject with: aDShape context: aContext [

	^ aDShape
]

{ #category : #computing }
GeoObjectProcessData >> processRecycledData: aKey incoming: aGeoObject with: aDShape context: aContext [
	
	aDShape key: nil.
	aDShape removeProperties.
	aDShape isComposite ifTrue:[ 
		aDShape dShapeList removeAll.
		aDShape toUpdateDShapeList removeAll.
		aDShape toDeleteDShapeList removeAll.
	].

	^ aDShape
]

{ #category : #computing }
GeoObjectProcessData >> processStateChanged: aKey state: aState value: aValueOrNil with: aDShape context: aContext [

	^ aDShape
]

{ #category : #computing }
GeoObjectProcessData >> processUpdatedData: aKey incoming: aGeoObject with: aDShape context: aContext [

	aDShape isVisible: aGeoObject isVisible.
	self computePosition: aKey incoming: aGeoObject with: aDShape context: aContext.
	self computeDisplayFilter: aKey incoming: aGeoObject with: aDShape context: aContext.

	^ aDShape
]
