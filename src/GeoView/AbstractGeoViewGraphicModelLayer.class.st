Class {
	#name : #AbstractGeoViewGraphicModelLayer,
	#superclass : #AbstractGeoViewLayer,
	#traits : 'TSmockHandleDShapes',
	#classTraits : 'TSmockHandleDShapes classTrait',
	#instVars : [
		'sortedDatas',
		'graphicModel',
		'graphicalOrderSortBlock',
		'isDatasChanged',
		'userDataChangesMutex'
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
	self sendRepaintRequest
]

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> addDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].

	"convert dShape to gShape"
	aDShapeList do: [ :e | self graphicModel created: e ].
	self isDatasChanged: true.
	self sendRepaintRequest
]

{ #category : #drawing }
AbstractGeoViewGraphicModelLayer >> aeDrawOn: aeCanvas [

	self isVisible ifFalse: [ ^ self ].
	self isDatasChanged ifTrue: [ self sortDatas ].
	self datasAeDrawOn: aeCanvas
]

{ #category : #drawing }
AbstractGeoViewGraphicModelLayer >> datasAeDrawOn: aeCanvas [

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

	"be carrefull this model can be asynchronous due to an update in bloc task"

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
	
	"Initialize a default graphic projection to work locally, will be change when the layer will be added in a geoview"
	self graphicModel projection: GeoView2DProjection new.
	
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

	| datas |
	datas := self graphicModel getDatas.
	datas do: [ :gShape |
		self
			populatePickingResult: aPickingResult
			at: gShape id
			with: gShape ]
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
	self isDatasChanged: true.
	self sendRepaintRequest
]

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].

	aDShapeList do: [ :e | self graphicModel deleted: e ].
	self isDatasChanged: true.
	self sendRepaintRequest
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> sortDatas [
	"force sorted to remove and add datas"

	| datas |
	self flag: 'execute this method into a dedicated BlocPhase'.

	self userDataChangesMutex critical: [
		datas := self graphicModel getDatas ].

	sortedDatas ifNil: [ ^ self ].
	sortedDatas removeAll.
	sortedDatas addAll: datas.

	self isDatasChanged: false
]

{ #category : #'API -- symbology' }
AbstractGeoViewGraphicModelLayer >> symbologyProvider: aSymbologyProvider [

	self graphicModel symbologyProvider: aSymbologyProvider
]

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> updateDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	self graphicModel updated: aDShape.
	self isDatasChanged: true.
	self sendRepaintRequest
]

{ #category : #'API -- DShapes' }
AbstractGeoViewGraphicModelLayer >> updateDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].

	aDShapeList do: [ :e | self graphicModel updated: e ].
	self isDatasChanged: true.
	self sendRepaintRequest
]

{ #category : #private }
AbstractGeoViewGraphicModelLayer >> updateGraphicModelWith: aDShape [
	"Update the graphic model with a DShape"

	"Call only on the mutex critical block"

	^ self graphicModel updated: aDShape
]

{ #category : #accessing }
AbstractGeoViewGraphicModelLayer >> userDataChangesMutex [

	^ userDataChangesMutex ifNil: [
		  userDataChangesMutex := Semaphore forMutualExclusion ]
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewGraphicModelLayer >> viewInfos [

	^ self graphicModel viewInfos
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewGraphicModelLayer >> viewInfos: aViewInfos [

	self graphicModel viewInfos: aViewInfos
]
