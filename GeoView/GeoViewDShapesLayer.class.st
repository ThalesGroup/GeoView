Class {
	#name : #GeoViewDShapesLayer,
	#superclass : #AbstractGeoViewLayer,
	#traits : 'TGeoViewHandleDShapes',
	#classTraits : 'TGeoViewHandleDShapes classTrait',
	#instVars : [
		'sortedDatas',
		'graphicModel',
		'graphicalOrderSortBlock'
	],
	#category : #'GeoView-Core'
}

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> addDShape: aDShape [

	aDShape ifNil:[ ^ self ].

	"convert dShape to gShape"
	self graphicModel created: aDShape
]

{ #category : #private }
GeoViewDShapesLayer >> checkPickingResultFor: aPickingResult at: index with: aGShape [
	"Way to detect if the gShape is picked"

	| distanceInPixels pickingElement |
	distanceInPixels := aPickingResult distanceBlock value: aGShape value: aPickingResult localPoint.
	(distanceInPixels notNil and: [ distanceInPixels <= aPickingResult radiusInPixels ]) ifFalse: [ ^ nil ].

	"Store the element into the result"
	pickingElement := GeoViewPickingElement new.
	pickingElement layerName: self name.
	pickingElement layerLevel: nil.
	self flag: 'labordep: put the level of the layer'.
	pickingElement distanceInPixels: distanceInPixels.
	pickingElement objectIndex: index.
	pickingElement gShape: aGShape.

	aPickingResult addPickingElement: pickingElement.
	
 	^ pickingElement 
]

{ #category : #accessing }
GeoViewDShapesLayer >> graphicModel [

	^ graphicModel
]

{ #category : #accessing }
GeoViewDShapesLayer >> graphicModel: anObject [

	graphicModel := anObject
]

{ #category : #'API -- projection' }
GeoViewDShapesLayer >> graphicProjection [

	^ self graphicModel projection
]

{ #category : #'API -- projection' }
GeoViewDShapesLayer >> graphicProjection: aGraphicProjection [

	self graphicModel projection: aGraphicProjection.
	self graphicModel viewInfos: aGraphicProjection
]

{ #category : #'API -- drawing' }
GeoViewDShapesLayer >> graphicalOrderSortBlock [
	"Setup a sort block to change the order of graphic element stack"

	^ graphicalOrderSortBlock ifNil: [
		  graphicalOrderSortBlock := [ :gShapeA :gShapeB |
		                             (gShapeA isPropertyExists: #selected)
			                             not ] ]
]

{ #category : #'API -- drawing' }
GeoViewDShapesLayer >> graphicalOrderSortBlock: aBlockClosure [
	"Setup a sort block to change the order of graphic element stack"
	
	graphicalOrderSortBlock := aBlockClosure.
	sortedDatas ifNotNil:[ :e | 
		e sortBlock: self graphicalOrderSortBlock. 
		self sortDatas 
	]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> haveDShapeKey: aKey [

	^ self graphicModel haveDataIndex: aKey
]

{ #category : #testing }
GeoViewDShapesLayer >> haveDShapes [

	^ true
]

{ #category : #initialization }
GeoViewDShapesLayer >> initialize [

	super initialize.
	self initializeDisplayToGraphicModel.
	self initializeSortedDatas
]

{ #category : #initialize }
GeoViewDShapesLayer >> initializeDisplayToGraphicModel [

	self graphicModel: GeoViewModel new
]

{ #category : #initialize }
GeoViewDShapesLayer >> initializeSortedDatas [
	
	sortedDatas := SortedCollection new: self graphicModel capacity.
	
	"Sort by selected state"
	sortedDatas sortBlock: self graphicalOrderSortBlock
]

{ #category : #'API -- picking' }
GeoViewDShapesLayer >> populatePickingResult: aPickingResult [

	self graphicModel datas keysAndValuesDo: [ :index :gShape |
		self checkPickingResultFor: aPickingResult at: index with: gShape ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> removeDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	"remove gShape"
	self graphicModel deleted: aDShape
]

{ #category : #initialize }
GeoViewDShapesLayer >> sortDatas [

	sortedDatas removeAll.
	sortedDatas addAll: self graphicModel getDatas
]

{ #category : #'API -- symbology' }
GeoViewDShapesLayer >> symbologyProvider: aSymbologyProvider [
	
	self graphicModel symbologyProvider: aSymbologyProvider
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> updateDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	"update gShape with dShape"
	self graphicModel updated: aDShape
]

{ #category : #'API -- drawing' }
GeoViewDShapesLayer >> updateGraphicModel [

	"do nothing"
]

{ #category : #private }
GeoViewDShapesLayer >> updateGraphicModelFor: aDShape [
	"Update the graphic model of a DShape"
	
	^ self graphicModel updated: aDShape
]
