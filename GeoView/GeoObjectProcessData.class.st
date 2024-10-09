Class {
	#name : #GeoObjectProcessData,
	#superclass : #SmockProcessData,
	#category : #'GeoView-ProcessDatas'
}

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

{ #category : #processing }
GeoObjectProcessData >> processCreatedData: aKey incoming: aGeoObject with: aDShape context: aContext [
	| dShape |
	dShape := aDShape.
	self assert: [dShape notNil] description: ['[ProcessGeoObject] DShape can not be nil because this process data cannot be used singulary.' ].
	
	dShape key: aGeoObject key.
	dShape isVisible: aGeoObject isVisible.
	self computePosition: aKey incoming: aGeoObject with: aDShape context: aContext.
	
	^dShape
]

{ #category : #processing }
GeoObjectProcessData >> processDeletedData: aKey incoming: aGeoObject with: aDShape context: aContext [
	^aDShape
]

{ #category : #processing }
GeoObjectProcessData >> processUpdatedData: aKey incoming: aGeoObject with: aDShape context: aContext [

	aDShape isVisible: aGeoObject isVisible.
	self computePosition: aKey incoming: aGeoObject with: aDShape context: aContext.

	^ aDShape
]
