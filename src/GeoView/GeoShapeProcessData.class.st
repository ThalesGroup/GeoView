Class {
	#name : #GeoShapeProcessData,
	#superclass : #GeoObjectProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #processing }
GeoShapeProcessData >> processCreatedData: aKey incoming: aGeoShape with: aDShape context: aContext [
	| dShape |
	dShape := aDShape.
	self assert: [dShape notNil] description: ['[ProcessGeoShape] DLeafShape can not be nil because this process data cannot be used singulary.' ].
	super processCreatedData: aKey incoming: aGeoShape with: dShape context: aContext.
	
	dShape isComposite ifFalse:[
		dShape fillStyle: aGeoShape fillStyle copy.
		dShape strokeStyle: aGeoShape strokeStyle copy.	
	].
	
	^ dShape
]

{ #category : #processing }
GeoShapeProcessData >> processUpdatedData: aKey incoming: aGeoShape with: aDShape context: aContext [
	| dShape |
	dShape := aDShape.
	super processUpdatedData: aKey incoming: aGeoShape with: dShape context: aContext.
	
	dShape isComposite ifFalse:[
		dShape fillStyle: aGeoShape fillStyle copy.
		dShape strokeStyle: aGeoShape strokeStyle copy.	
	].

	^ dShape
]
