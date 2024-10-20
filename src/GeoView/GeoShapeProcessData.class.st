Class {
	#name : #GeoShapeProcessData,
	#superclass : #GeoObjectProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #processing }
GeoShapeProcessData >> processCreatedData: aKey incoming: aGeoShape with: aDLeafShape context: aContext [
	| dLeafShape |
	dLeafShape := aDLeafShape.
	self assert: [dLeafShape notNil] description: ['[ProcessGeoShape] DLeafShape can not be nil because this process data cannot be used singulary.' ].
	 super processCreatedData: aKey incoming: aGeoShape with: dLeafShape context: aContext.
	
	dLeafShape fillStyle: aGeoShape fillStyle copy.
	dLeafShape strokeStyle: aGeoShape strokeStyle copy.	
	^dLeafShape
]

{ #category : #processing }
GeoShapeProcessData >> processUpdatedData: aKey incoming: aGeoShape with: aDLeafShape context: aContext [
	| dLeafShape |
	dLeafShape := aDLeafShape.
	super processUpdatedData: aKey incoming: aGeoShape with: dLeafShape context: aContext.
	
	dLeafShape fillStyle: aGeoShape fillStyle copy.
	dLeafShape strokeStyle: aGeoShape strokeStyle copy.	
	^dLeafShape
]
