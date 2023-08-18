Class {
	#name : #GeoObjectProcessData,
	#superclass : #GeoProcessData,
	#category : #'GeoView-GeoObjects-ProcessData'
}

{ #category : #processing }
GeoObjectProcessData >> processCreatedData: aKey incoming: aGeoObject with: aDShape context: aContext [
	| dShape coordinates |
	dShape := aDShape.
	self assert: [dShape notNil] description: ['[ProcessGeoObject] DShape can not be nil because this process data cannot be used singulary.' ].
	
	dShape key: aGeoObject key.
	dShape isVisible: aGeoObject isVisible.
	
	aGeoObject absoluteCoordinates ifNotNil:[
		coordinates :=  self processor projection projLatLonToCart: (aGeoObject absoluteCoordinates). 
		dShape coordinates: coordinates.
	].
	
	^dShape
]

{ #category : #processing }
GeoObjectProcessData >> processDeletedData: aKey incoming: aGeoObject with: aDShape context: aContext [
	^aDShape
]

{ #category : #processing }
GeoObjectProcessData >> processUpdatedData: aKey incoming: aGeoObject with: aDShape context: aContext [
	| coordinates |
	aDShape isVisible: aGeoObject isVisible.
	
	aGeoObject absoluteCoordinates ifNotNil:[
		coordinates :=  self processor projection projLatLonToCart: (aGeoObject absoluteCoordinates). 
		aDShape coordinates: coordinates.
	] ifNil:[
		aDShape coordinates: nil.
	].

	^aDShape
]
