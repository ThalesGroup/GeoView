Class {
	#name : #AbstractGeoViewGraphicModelLayer,
	#superclass : #AbstractGeoViewLayer,
	#instVars : [
		'graphicModel',
		'graphicalOrderSortBlock',
		'isNeedToSortDatas',
		'dirtyDShapes',
		'maximumDisplayedObjects',
		'isMaximumDisplayedObjectsReach',
		'displayModelMutex',
		'graphicModelMutex',
		'toBeDisplayDatas'
	],
	#category : #'GeoView-Layers'
}

{ #category : #sorting }
AbstractGeoViewGraphicModelLayer class >> defaultGraphicalOrderSortBlock [
	"Setup a sort block to change the order of graphic element stack"

	"this default sort block place all selected shapes on top of the drawing"

	^ [ :gShapeA :gShapeB | (gShapeA isPropertyExists: #selected) not ]
]

{ #category : #testing }
AbstractGeoViewGraphicModelLayer class >> isAbstract [ 

	^ self == AbstractGeoViewGraphicModelLayer 
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> addDShape: aDShape [

	aDShape ifNil:[ ^ self ].

	"convert dShape to gShape"
	self addDShapeInGraphicModel: aDShape.
	self needToSortDatas
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> addDShapeInGraphicModel: aDShape [

	self graphicModel created: aDShape.
	self isVisible ifTrue:[ self sendRepaintRequest ].
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> addDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].
	aDShapeList ifEmpty: [ ^ self ].

	"convert dShape to gShape"
	self addDShapesInGraphicModel: aDShapeList.
	self needToSortDatas
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> addDShapesInGraphicModel: aDShapeList [

	aDShapeList do: [ :e | self graphicModel created: e ].
	aDShapeList ifEmpty: [ ^ self ].
	
	self isVisible ifTrue:[ self sendRepaintRequest ].
]

{ #category : #drawing }
AbstractGeoViewGraphicModelLayer >> aeDrawOn: aeCanvas [

	self datasAeDrawOn: aeCanvas
]

{ #category : #drawing }
AbstractGeoViewGraphicModelLayer >> datasAeDrawOn: aeCanvas [

	toBeDisplayDatas ifNil: [ ^ self ].
	toBeDisplayDatas do: [ :e | e aeDrawOn: aeCanvas ]
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> dirtyDShapes [

	^ dirtyDShapes ifNil: [ dirtyDShapes := Dictionary new ]
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> dirtyDShapes: anObject [

	dirtyDShapes := nil
]

{ #category : #accessing }
AbstractGeoViewGraphicModelLayer >> displayModelMutex [

	^ displayModelMutex ifNil: [
		  displayModelMutex := Monitor new ]
]

{ #category : #accessing }
AbstractGeoViewGraphicModelLayer >> graphicModel [

	^ graphicModel
]

{ #category : #accessing }
AbstractGeoViewGraphicModelLayer >> graphicModel: anObject [

	graphicModel := anObject
]

{ #category : #accessing }
AbstractGeoViewGraphicModelLayer >> graphicModelMutex [

	^ graphicModelMutex ifNil: [
		  graphicModelMutex := Monitor new ]
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

	^ graphicalOrderSortBlock
]

{ #category : #'API -- drawing' }
AbstractGeoViewGraphicModelLayer >> graphicalOrderSortBlock: aBlockClosure [
	"Setup a sort block to change the order of graphic element stack"

	graphicalOrderSortBlock ~= aBlockClosure ifFalse: [ ^ self ].

	graphicalOrderSortBlock := aBlockClosure.
	self updateToBeDisplayedDatas
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> haveDShapeKey: aKey [
	"check in the graphic model because if not present here, the object is not managed"

	aKey ifNil: [ ^ false ].
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
	self initializeToBeDisplayedDatas.

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
	self graphicModel setProcessData: DEllipseGeoViewProcessData new forClass: SmockDEllipse. 
	self graphicModel setProcessData: DTextGeoViewProcessData new forClass: SmockDText. 
	self graphicModel setProcessData: DPolygonGeoViewProcessData new forClass: SmockDPolygon.
	self graphicModel setProcessData: DPolylineGeoViewProcessData new forClass: SmockDPolyline.
	self graphicModel setProcessData: DSegmentGeoViewProcessData new forClass: SmockDSegment.
	self graphicModel setProcessData: DSectorGeoViewProcessData new forClass: SmockDSector.
	
]

{ #category : #initialization }
AbstractGeoViewGraphicModelLayer >> initializeToBeDisplayedDatas [

	toBeDisplayDatas := OrderedCollection new: self graphicModel capacity
]

{ #category : #'API -- drawing' }
AbstractGeoViewGraphicModelLayer >> isMaximumDisplayedObjectsReach [

	^ isMaximumDisplayedObjectsReach ifNil: [
		  isMaximumDisplayedObjectsReach := false ]
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> isNeedToSortDatas [

	^ isNeedToSortDatas ifNil: [ isNeedToSortDatas := false ]
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> isNeedToSortDatas: aBoolean [

	isNeedToSortDatas := aBoolean
]

{ #category : #'API -- drawing' }
AbstractGeoViewGraphicModelLayer >> maximumDisplayedObjects [
	"basic way to limit the number of displayed objects in case of too much datas"
	
	^ maximumDisplayedObjects
]

{ #category : #'API -- drawing' }
AbstractGeoViewGraphicModelLayer >> maximumDisplayedObjects: aNumber [
	"basic way to limit the number of displayed objects in case of too much datas"
	
	maximumDisplayedObjects := aNumber 
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> needToSortDatas [
	"call this method when the data model have changed: create, update of delete something"

	self isNeedToSortDatas ifTrue: [ ^ self ].
	self isNeedToSortDatas: true.
	"sort only when the layer is visible, then sort on visibility change"
	self isVisible ifTrue:[ self sendSortRequest ]
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

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> populateSortedDatasLimited: aCollection [

	| temp limitedDatas |
	temp := toBeDisplayDatas copy.
	temp addAll: aCollection.
	limitedDatas := temp copyFrom: 1 to: (self maximumDisplayedObjects min: temp size).
	
	(toBeDisplayDatas isKindOf: SortedCollection) ifTrue:[
		limitedDatas do: [ :e | toBeDisplayDatas addNoSort: e ].
	] ifFalse:[
		toBeDisplayDatas addAll: limitedDatas.
	].

	self isMaximumDisplayedObjectsReach ifTrue: [ ^ self ].
	isMaximumDisplayedObjectsReach := true.
	self announce: GeoViewLayerReachMaximumDisplayedObjectsEvent new
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> populateSortedDatasNormally: aCollection [
	"force sorted to remove and add datas - execute my only with a bloc command applier - return true / false if need to repaint"

	self isMaximumDisplayedObjectsReach ifTrue:[ isMaximumDisplayedObjectsReach := false ].
	toBeDisplayDatas addAll: aCollection.

]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> populateSortedDatasWith: aCollection [
	"force sorted to remove and add datas - execute my only with a bloc command applier - return true / false if need to repaint"

	(self maximumDisplayedObjects notNil and:[ aCollection size > self maximumDisplayedObjects ]) ifTrue:[ 
		self populateSortedDatasLimited: aCollection
	] ifFalse:[
		self populateSortedDatasNormally: aCollection
	].
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	"remove gShape"
	self removeDShapeFromGraphicModel: aDShape.
	self needToSortDatas
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShapeFromGraphicModel: aDShape [

	self graphicModel deleted: aDShape.
	self isVisible ifTrue:[ self sendRepaintRequest ].
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].
	aDShapeList ifEmpty:[ ^ self ].

	self removeDShapesFromGraphicModel: aDShapeList.
	self needToSortDatas
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShapesFromGraphicModel: aDShapeList [

	aDShapeList do: [ :e | self graphicModel deleted: e ].
	aDShapeList ifEmpty: [ ^ self ].
	
	self isVisible ifTrue:[ self sendRepaintRequest ].
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> sendSortRequest [
	"Notify that the layer need to be sorted"
	
	| announcement |
	announcement := GeoViewGraphicModelLayerSortRequest new.
	announcement layerName: self name; layer: self.
	self announcer announce: announcement
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> sortDatas [
	"force sorted to remove and add datas - execute my only with a bloc command applier - return true / false if need to repaint"

	| sortableDatas |
	toBeDisplayDatas ifNil: [ ^ self ].
	self graphicModelMutex critical: [
		self isNeedToSortDatas: false.
		sortableDatas := self graphicModel getDatas ].

	"select only drawable datas to sort"
	sortableDatas := sortableDatas select: [ :e | e isDrawable ].

	"sort by reset content of the list"
	toBeDisplayDatas removeAll.
	self populateSortedDatasWith: sortableDatas
]

{ #category : #'API -- symbology' }
AbstractGeoViewGraphicModelLayer >> symbologyProvider [

	^ self graphicModel symbologyProvider
]

{ #category : #'API -- symbology' }
AbstractGeoViewGraphicModelLayer >> symbologyProvider: aSymbologyProvider [

	self graphicModel symbologyProvider: aSymbologyProvider
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> updateDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	self isVisible ifFalse:[ 
		"doesn't update when the layer is not visible, waiting for update when the visibility is on"
		self dirtyDShapes at: (aDShape key) put: aDShape.
		^ self
	].

	self updateGraphicModelWithDShape: aDShape
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> updateDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].
	aDShapeList ifEmpty:[ ^ self ].

	self isVisible ifFalse:[ 
		"doesn't update when the layer is not visible, waiting for update when the visibility is on"
		aDShapeList do:[ :e | self dirtyDShapes at: (e key) put: e ].
		^ self
	].

	self updateGraphicModelWithDShapes: aDShapeList
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> updateGraphicModelWithDShape: aDShape [

	self graphicModel updated: aDShape.
	
	self needToSortDatas.
	self isVisible ifTrue:[ self sendRepaintRequest ].
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> updateGraphicModelWithDShapes: aDShapeList [

	aDShapeList do: [ :e | self graphicModel updated: e ].
	aDShapeList ifEmpty: [ ^ self ].
	
	self needToSortDatas.
	self isVisible ifTrue:[ self sendRepaintRequest ].
]

{ #category : #initialization }
AbstractGeoViewGraphicModelLayer >> updateToBeDisplayedDatas [

	graphicalOrderSortBlock ifNil:[
		self initializeToBeDisplayedDatas.
	]ifNotNil: [ :e |
		(toBeDisplayDatas isKindOf: SortedCollection) ifFalse:[ 
			toBeDisplayDatas := SortedCollection new: self graphicModel capacity.
		].
		toBeDisplayDatas sortBlock: self graphicalOrderSortBlock.
		self needToSortDatas.
	].
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewGraphicModelLayer >> viewInfos [

	^ self graphicModel viewInfos
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewGraphicModelLayer >> viewInfos: aViewInfos [

	self graphicModel viewInfos: aViewInfos
]
