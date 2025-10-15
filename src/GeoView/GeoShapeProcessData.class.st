Class {
	#name : #GeoShapeProcessData,
	#superclass : #GeoObjectProcessData,
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #accessing }
GeoShapeProcessData class >> isAbstract [

	^ self == GeoShapeProcessData
]

{ #category : #dShape }
GeoShapeProcessData >> createDShapeInstance [

	^ self subclassResponsibility 
]

{ #category : #processing }
GeoShapeProcessData >> processCreatedData: aKey incoming: aGeoShape with: aDShape context: aContext [

	| dShape |
	dShape := aDShape ifNil: [ self createDShapeInstance ].

	super
		processCreatedData: aKey
		incoming: aGeoShape
		with: dShape
		context: aContext.

	dShape isComposite ifFalse: [
		dShape fillStyle: aGeoShape fillStyle copy.
		dShape strokeStyle: aGeoShape strokeStyle copy ].

	^ dShape
]

{ #category : #processing }
GeoShapeProcessData >> processUpdatedData: aKey incoming: aGeoShape with: aDShape context: aContext [

	| dShape |
	dShape := aDShape.

	super
		processUpdatedData: aKey
		incoming: aGeoShape
		with: dShape
		context: aContext.

	dShape isComposite ifFalse: [
		dShape fillStyle: aGeoShape fillStyle copy.
		dShape strokeStyle: aGeoShape strokeStyle copy ].

	^ dShape
]
