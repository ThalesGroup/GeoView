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
	| dMultiPolylines points polylines |
	
	dMultiPolylines := aDMultiPolylines.
	super processUpdatedData: aKey incoming: aGeoBoundingBox with: dMultiPolylines context: aContext.
	
	points := OrderedCollection new.
	dMultiPolylines removePolylines.
	
	polylines := self projectBoundingBox: aGeoBoundingBox.
	polylines ifNotNil:[ :e | dMultiPolylines addPolylines: e ].
	
	^ dMultiPolylines
]
