Class {
	#name : #AbstractGeoViewGraphicModelLayer,
	#superclass : #AbstractGeoViewLayer,
	#traits : 'TSmockHandleDShapes',
	#classTraits : 'TSmockHandleDShapes classTrait',
	#instVars : [
		'sortedDatas',
		'graphicModel',
		'graphicalOrderSortBlock',
		'isDatasChanged'
	],
	#category : #'GeoView-Layers'
}

{ #category : #testing }
AbstractGeoViewGraphicModelLayer class >> isAbstract [ 

	^ self == AbstractGeoViewGraphicModelLayer 
]

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> addDShape: aDShape [

	aDShape ifNil:[ ^ self ].

	"convert dShape to gShape"
	self graphicModel created: aDShape.
	self isDatasChanged: true.
]

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> addDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].
	aDShapeList do: [ :e | self addDShape: e ]
]

{ #category : #'drawing - bloc' }
AbstractGeoViewGraphicModelLayer >> aeDrawOn: aeCanvas [

	self isVisible ifFalse: [ ^ self ].
	self isDatasChanged ifTrue:[
		"flag labordep: need to this on a dedicated phase instead of in the render"
		self sortDatas.	
	].
	
	sortedDatas ifNil: [ ^ self ].
	sortedDatas do: [ :e | e aeDrawOn: aeCanvas ]
]

{ #category : #accessing }
AbstractGeoViewGraphicModelLayer >> graphicModel [

	^ graphicModel
]

{ #category : #accessing }
AbstractGeoViewGraphicModelLayer >> graphicModel: anObject [

	graphicModel := anObject
]

{ #category : #'API -- projection' }
AbstractGeoViewGraphicModelLayer >> graphicProjection [

	^ self graphicModel projection
]

{ #category : #'API -- projection' }
AbstractGeoViewGraphicModelLayer >> graphicProjection: aGraphicProjection [

	self graphicModel projection: aGraphicProjection
]

{ #category : #'API -- drawing' }
AbstractGeoViewGraphicModelLayer >> graphicalOrderSortBlock [
	"Setup a sort block to change the order of graphic element stack"

	^ graphicalOrderSortBlock ifNil: [
		  graphicalOrderSortBlock := [ :gShapeA :gShapeB | "this default sort block place all selected shapes on top of the drawing"
		                             (gShapeA isPropertyExists: #selected)
			                             not ] ]
]

{ #category : #'API -- drawing' }
AbstractGeoViewGraphicModelLayer >> graphicalOrderSortBlock: aBlockClosure [
	"Setup a sort block to change the order of graphic element stack"
	
	graphicalOrderSortBlock := aBlockClosure.
	sortedDatas ifNotNil:[ :e | 
		e sortBlock: self graphicalOrderSortBlock. 
	]
]

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> haveDShapeKey: aKey [
	"check in the graphic model because if not present here, the object is not managed"

	aKey ifNil: [ ^ self ].
	^ self graphicModel haveDataIndex: aKey
]

{ #category : #testing }
AbstractGeoViewGraphicModelLayer >> haveGraphicModel [

	^ true
]

{ #category : #initialization }
AbstractGeoViewGraphicModelLayer >> initialize [

	super initialize.
	self initializeGraphicModel.
	self initializeSortedDatas.
]

{ #category : #initialization }
AbstractGeoViewGraphicModelLayer >> initializeGraphicModel [

	self graphicModel: GeoViewModel new.
	
	"Setup all DShape process datas"
	self graphicModel setProcessData: DCompositeShapeGeoViewProcessData new forClass: SmockDCompositeShape.
	self graphicModel setProcessData: DSymbolGeoViewProcessData new forClass: SmockDSymbol.
	self graphicModel setProcessData: DImageGeoViewProcessData new forClass: SmockDImage.
	self graphicModel setProcessData: DCircleGeoViewProcessData new forClass: SmockDCircle.
	self graphicModel setProcessData: DTextGeoViewProcessData new forClass: SmockDText.
	self graphicModel setProcessData: DPolygonGeoViewProcessData new forClass: SmockDPolygon.
	self graphicModel setProcessData: DPolylineGeoViewProcessData new forClass: SmockDPolyline.
	self graphicModel setProcessData: DSegmentGeoViewProcessData new forClass: SmockDSegment.
	
]

{ #category : #initialization }
AbstractGeoViewGraphicModelLayer >> initializeSortedDatas [

	sortedDatas := SortedCollection new: self graphicModel capacity.
	sortedDatas sortBlock: self graphicalOrderSortBlock
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> isDatasChanged [

	^ isDatasChanged ifNil: [ isDatasChanged := false ]
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> isDatasChanged: aBoolean [

	isDatasChanged := aBoolean
]

{ #category : #'API -- picking' }
AbstractGeoViewGraphicModelLayer >> populatePickingResult: aPickingResult [

	self graphicModel datas keysAndValuesDo: [ :index :gShape |
		self populatePickingResult: aPickingResult at: index with: gShape ]
]

{ #category : #private }
AbstractGeoViewGraphicModelLayer >> populatePickingResult: aPickingResult at: index with: aGShape [
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

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	"remove gShape"
	self graphicModel deleted: aDShape.
	self isDatasChanged: true
]

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].
	aDShapeList do: [ :e | self removeDShape: e ]
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> sortDatas [

	"force sorted to remove and add datas"
	sortedDatas removeAll.
	sortedDatas addAll: self graphicModel getDatas.
	self isDatasChanged: false.
]

{ #category : #'API -- symbology' }
AbstractGeoViewGraphicModelLayer >> symbologyProvider: aSymbologyProvider [
	
	self graphicModel symbologyProvider: aSymbologyProvider
]

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> updateDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	"update gShape with dShape"
	self graphicModel updated: aDShape.
	self isDatasChanged: true
]

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> updateDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].
	aDShapeList do: [ :e | self updateDShape: e ]
]

{ #category : #private }
AbstractGeoViewGraphicModelLayer >> updateGraphicModelWith: aDShape [
	"Update the graphic model with a DShape"
	
	^ self graphicModel updated: aDShape
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewGraphicModelLayer >> viewInfos [

	^ self graphicModel viewInfos
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewGraphicModelLayer >> viewInfos: aViewInfos [

	self graphicModel viewInfos: aViewInfos
]
