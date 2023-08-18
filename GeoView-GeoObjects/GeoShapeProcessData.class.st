Class {
	#name : #GeoShapeProcessData,
	#superclass : #GeoObjectProcessData,
	#category : #'GeoView-GeoObjects-ProcessData'
}

{ #category : #processing }
GeoShapeProcessData >> processCreatedData: aKey incoming: aGeoShape with: aDLeafShape context: aContext [
	| dLeafShape |
	dLeafShape := aDLeafShape.
	self assert: [dLeafShape notNil] description: ['[ProcessGeoShape] DLeafShape can not be nil because this process data cannot be used singulary.' ].
	 super processCreatedData: aKey incoming: aGeoShape with: dLeafShape context: aContext.
	
	dLeafShape fillColor: aGeoShape fillColor copy.
	dLeafShape strokeColor: aGeoShape strokeColor copy.
	dLeafShape strokePattern: aGeoShape strokePattern copy.
	dLeafShape strokeWidth: aGeoShape strokeWidth.
	
	^dLeafShape
]

{ #category : #processing }
GeoShapeProcessData >> processUpdatedData: aKey incoming: aGeoShape with: aDLeafShape context: aContext [
	| dLeafShape |
	dLeafShape := aDLeafShape.
	super processUpdatedData: aKey incoming: aGeoShape with: dLeafShape context: aContext.
	
	dLeafShape fillColor: aGeoShape fillColor.
	dLeafShape strokeColor: aGeoShape strokeColor.
	dLeafShape strokePattern: aGeoShape strokePattern.
	dLeafShape strokeWidth: aGeoShape strokeWidth.
	
	^dLeafShape
]
