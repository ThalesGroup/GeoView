Class {
	#name : #GeoBoundingBoxProjectedProcessData,
	#superclass : #GeoShapeProcessData,
	#traits : 'TGeoProjectorProcessData',
	#classTraits : 'TGeoProjectorProcessData classTrait',
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #computing }
GeoBoundingBoxProjectedProcessData >> computePosition: aKey incoming: aGeoObject with: aDShape context: aContext [
	"Position makes no sense for a GeoBoundingBox"

	^ aDShape
]

{ #category : #dShape }
GeoBoundingBoxProjectedProcessData >> createDShapeInstance [

	^ SmockDMultiPolylines new
]

{ #category : #processing }
GeoBoundingBoxProjectedProcessData >> processCreatedData: aKey incoming: aGeoBoundingBox with: aDMultiPolylines context: aContext [
	| dMultiPolylines |
	
	dMultiPolylines := aDMultiPolylines.
	dMultiPolylines := super processCreatedData: aKey incoming: aGeoBoundingBox with: dMultiPolylines context: aContext.
	
	self processUpdatedData: aKey incoming: aGeoBoundingBox with: dMultiPolylines context: aContext.
	
	^dMultiPolylines
]

{ #category : #processing }
GeoBoundingBoxProjectedProcessData >> processUpdatedData: aKey incoming: aGeoBoundingBox with: aDMultiPolylines context: aContext [
	| dMultiPolylines points |
	
	dMultiPolylines := aDMultiPolylines.
	super processUpdatedData: aKey incoming: aGeoBoundingBox with: aDMultiPolylines context: aContext.
	
	points := OrderedCollection new.
	
	aDMultiPolylines addPolylines: (self projectGeodesicFrom: aGeoBoundingBox topLeftAbsoluteCoordinates to: aGeoBoundingBox topRightAbsoluteCoordinates).
	aDMultiPolylines addPolylines: (self projectGeodesicFrom: aGeoBoundingBox topRightAbsoluteCoordinates to: aGeoBoundingBox bottomRightAbsoluteCoordinates).
	aDMultiPolylines addPolylines: (self projectGeodesicFrom: aGeoBoundingBox bottomRightAbsoluteCoordinates to: aGeoBoundingBox bottomLeftAbsoluteCoordinates).
	aDMultiPolylines addPolylines: (self projectGeodesicFrom: aGeoBoundingBox bottomLeftAbsoluteCoordinates to: aGeoBoundingBox topLeftAbsoluteCoordinates).
	
	^dMultiPolylines
]
