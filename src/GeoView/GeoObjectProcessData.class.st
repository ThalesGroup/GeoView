Class {
	#name : #GeoObjectProcessData,
	#superclass : #SmockProcessData,
	#instVars : [
		'displayFilterBlock'
	],
	#category : #'GeoView-ProcessDatas'
}

{ #category : #accessing }
GeoObjectProcessData class >> isAbstract [ 

	^ self == GeoObjectProcessData 
]

{ #category : #private }
GeoObjectProcessData >> computeDisplayFilter: aKey incoming: aTObject with: aDShape context: aContext [

	"propose a block to setup the filter externally"
	self displayFilterBlock ifNotNil:[ :b | b cull: aKey cull: aTObject cull: aDShape cull: aContext ].

	^ aDShape
]

{ #category : #private }
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

{ #category : #accessing }
GeoObjectProcessData >> displayFilterBlock [

	^ displayFilterBlock
]

{ #category : #accessing }
GeoObjectProcessData >> displayFilterBlock: anObject [

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
	aDShape isComposite ifTrue:[ 
		aDShape dShapeList removeAll.
		aDShape toUpdateDShapeList removeAll.
		aDShape toDeleteDShapeList removeAll.
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
