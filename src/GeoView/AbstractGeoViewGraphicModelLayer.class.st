Class {
	#name : #AbstractGeoViewGraphicModelLayer,
	#superclass : #AbstractGeoViewLayer,
	#instVars : [
		'graphicModel',
		'displayModel',
		'graphicalOrderSortBlock',
		'isNeedToSortDatas',
		'maximumDisplayedObjects',
		'isMaximumDisplayedObjectsReach',
		'displayModelMutex',
		'graphicModelMutex',
		'toBeDisplayDatas',
		'dShapesWaitingToBeUpdated'
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

	aDShape ifNil:[ ^ self ].
	self graphicModelMutex critical:[ self graphicModel created: aDShape ].
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

	aDShapeList ifEmpty: [ ^ self ].
	self graphicModelMutex critical:[ aDShapeList do: [ :e | self graphicModel created: e ] ].
	
	self isVisible ifTrue:[ self sendRepaintRequest ].
]

{ #category : #drawing }
AbstractGeoViewGraphicModelLayer >> aeDrawOn: aeCanvas [

	self datasAeDrawOn: aeCanvas
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> dShapesWaitingToBeUpdated [
	"this list contains DShape which need to be updated when the layer becomes visible"

	^ dShapesWaitingToBeUpdated ifNil: [ dShapesWaitingToBeUpdated := Dictionary new ]
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> dShapesWaitingToBeUpdated: anObject [

	dShapesWaitingToBeUpdated := nil
]

{ #category : #drawing }
AbstractGeoViewGraphicModelLayer >> datasAeDrawOn: aeCanvas [

	self toBeDisplayDatas ifNotNil: [ :datas |
		datas do: [ :e | e aeDrawOn: aeCanvas ] ]
]

{ #category : #'API -- filters' }
AbstractGeoViewGraphicModelLayer >> displayFilter [

	^ self graphicModel displayFilter
]

{ #category : #'API -- filters' }
AbstractGeoViewGraphicModelLayer >> displayFilter: aDisplayFilter [

	self graphicModel displayFilter: aDisplayFilter.
	self updateModel: GeoViewDisplayFilterChanges new
]

{ #category : #accessing }
AbstractGeoViewGraphicModelLayer >> displayModel [

	^ displayModel 
]

{ #category : #accessing }
AbstractGeoViewGraphicModelLayer >> displayModel: anObject [

	displayModel := anObject
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

	self initializeToBeDisplayDatas.
	self needToSortDatas
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> haveDShapeKey: aKey [
	"check in the graphic model because if not present here, the object is not managed"

	| have |
	aKey ifNil: [ ^ false ].
	self graphicModelMutex critical:[ have := self graphicModel haveDataIndex: aKey ].
	^ have
]

{ #category : #testing }
AbstractGeoViewGraphicModelLayer >> haveGraphicModel [

	^ true
]

{ #category : #initialization }
AbstractGeoViewGraphicModelLayer >> initialize [

	super initialize.
	self initializeGraphicModel.
	self initializeToBeDisplayDatas.
	self initializeDisplayModel
]

{ #category : #initialization }
AbstractGeoViewGraphicModelLayer >> initializeDisplayModel [

	self subclassResponsibility 
]

{ #category : #initialization }
AbstractGeoViewGraphicModelLayer >> initializeGraphicModel [

	self graphicModel: (GeoViewModel new name: 'Graphic Shape Model').
	
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
	self graphicModel setProcessData: DRectangleGeoViewProcessData new forClass: SmockDRectangle.
	self graphicModel setProcessData: DSectorGeoViewProcessData new forClass: SmockDSector.
	self graphicModel setProcessData: DSegmentGeoViewProcessData new forClass: SmockDSegment.
	self graphicModel setProcessData: DMultiPolylinesGeoViewProcessData new forClass: SmockDMultiPolylines.
	
]

{ #category : #initialization }
AbstractGeoViewGraphicModelLayer >> initializeToBeDisplayDatas [

	| capacity |
	capacity := self graphicModel capacity.

	self graphicalOrderSortBlock
		ifNil: [ toBeDisplayDatas := OrderedCollection new: capacity ]
		ifNotNil: [ :e |
				toBeDisplayDatas := SortedCollection new: capacity.
				toBeDisplayDatas sortBlock: self graphicalOrderSortBlock ]
]

{ #category : #'API -- filters' }
AbstractGeoViewGraphicModelLayer >> isGShapeDisplayed: aGShape [

	self displayFilter ifNil: [ ^ true ].
	^ self displayFilter isGShapeDisplayed: aGShape
]

{ #category : #'API -- filters' }
AbstractGeoViewGraphicModelLayer >> isGShapeNotDisplayed: aGShape [

	^ (self isGShapeDisplayed: aGShape) not
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

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> notifyLeaveMaximumDisplayedObjects [ 
	
	| announcement |
	announcement := GeoViewLayerLeaveMaximumDisplayedObjectsEvent new.
	announcement layerName: self name.
	self announcer announce: announcement
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> notifyReachMaximumDisplayedObjects [ 
	
	| announcement |
	announcement := GeoViewLayerReachMaximumDisplayedObjectsEvent new.
	announcement layerName: self name.
	self announcer announce: announcement
]

{ #category : #'API -- picking' }
AbstractGeoViewGraphicModelLayer >> populatePickingResult: aPickingResult [

	| datas |
  	self graphicModelMutex critical: [ datas := self graphicModel getDatas ].
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
	"limited way: cannot display all the datas"
	
	| temp limitedDatas |
	temp := self toBeDisplayDatas copy.
	temp addAll: aCollection.
	limitedDatas := temp copyFrom: 1 to: (self maximumDisplayedObjects min: temp size).
	
	self populateSortedDatasNormally: aCollection
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> populateSortedDatasNormally: aCollection [

	"sort by zIndex by default"
	aCollection sort: [ :a :b | a zIndex < b zIndex ].

	self toBeDisplayDatas addAll: aCollection
]

{ #category : #'private - sort' }
AbstractGeoViewGraphicModelLayer >> populateSortedDatasWith: aCollection [
	"force sorted to remove and add datas - execute my only with a bloc command applier - return true / false if need to repaint"

	| isLimited |
	isLimited := self maximumDisplayedObjects notNil and: [
		             aCollection size > self maximumDisplayedObjects ].

	isLimited
		ifTrue: [
				self populateSortedDatasLimited: aCollection.

				self isMaximumDisplayedObjectsReach ifTrue: [ ^ self ].
				isMaximumDisplayedObjectsReach := true.
				self notifyReachMaximumDisplayedObjects ]
		ifFalse: [
				self populateSortedDatasNormally: aCollection.

				self isMaximumDisplayedObjectsReach ifFalse: [ ^ self ].
				isMaximumDisplayedObjectsReach := false.
				self notifyLeaveMaximumDisplayedObjects ]
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	"clean waiting shapes list"
	self dShapesWaitingToBeUpdated removeKey: aDShape key ifAbsent:[ nil ].

	"remove gShape"
	self removeDShapeFromGraphicModel: aDShape.
	self needToSortDatas
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShapeFromGraphicModel: aDShape [

	aDShape ifNil:[ ^ self ].
	self graphicModelMutex critical:[ self graphicModel deleted: aDShape ].
	self isVisible ifTrue:[ self sendRepaintRequest ].
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].
	aDShapeList ifEmpty:[ ^ self ].

	"clean waiting shapes list"
	aDShapeList do:[ :e | self dShapesWaitingToBeUpdated removeKey: e key ifAbsent:[ nil ] ].

	self removeDShapesFromGraphicModel: aDShapeList.
	self needToSortDatas
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> removeDShapesFromGraphicModel: aDShapeList [

	aDShapeList ifEmpty: [ ^ self ].
	self graphicModelMutex critical:[ aDShapeList do: [ :e |
		self graphicModel deleted: e
	] ].
	
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

	self toBeDisplayDatas ifNil: [ ^ self ].
	
	self graphicModelMutex critical: [
		self isNeedToSortDatas: false.
		sortableDatas := self graphicModel getDatas.
	].

	"select only drawable and unfiltered datas to sort"
	sortableDatas := sortableDatas select: [ :gShape | gShape isDrawable and:[ (self isGShapeDisplayed: gShape) ] ].

	"reset objects to display"
	self toBeDisplayDatas removeAll.
	
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

{ #category : #private }
AbstractGeoViewGraphicModelLayer >> toBeDisplayDatas [

	^ toBeDisplayDatas
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> updateDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	"doesn't update DShape when the layer is not visible, waiting for update when the visibility is on to adding each dShape in a waiting list"
	self isVisible ifFalse:[ 
		self dShapesWaitingToBeUpdated at: (aDShape key) put: aDShape.
		^ self
	].

	self updateGraphicModelWithDShape: aDShape
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> updateDShapes: aDShapeList [

	aDShapeList ifNil: [ ^ self ].
	aDShapeList ifEmpty:[ ^ self ].

	"doesn't update DShape when the layer is not visible, waiting for update when the visibility is on to adding each dShape in a waiting list"
	self isVisible ifFalse:[ 
		aDShapeList do:[ :e | self dShapesWaitingToBeUpdated at: (e key) put: e ].
		^ self
	].

	self updateGraphicModelWithDShapes: aDShapeList
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> updateGraphicModelWithDShape: aDShape [

	aDShape ifNil:[ ^ self ].
	self graphicModelMutex critical:[ self graphicModel updated: aDShape ].
	
	self needToSortDatas.
	self isVisible ifTrue:[ self sendRepaintRequest ].
]

{ #category : #'private - DShapes' }
AbstractGeoViewGraphicModelLayer >> updateGraphicModelWithDShapes: aDShapeList [

	aDShapeList ifEmpty: [ ^ self ].
	self graphicModelMutex critical:[ aDShapeList do: [ :e | self graphicModel updated: e ] ].
	
	self needToSortDatas.
	self isVisible ifTrue:[ self sendRepaintRequest ].
]

{ #category : #private }
AbstractGeoViewGraphicModelLayer >> updateModel: aContext [
	"don't update when not visible"

	self isVisible ifFalse: [ ^ self ].

	"process visibility changes"
	(aContext isBeVisibleChanges and: [ self isNeedToSortDatas ])
		ifTrue: [ self sendSortRequest ].

	"process display filter changes"
	aContext isDisplayFilterChanges ifTrue: [ self sendSortRequest ]
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewGraphicModelLayer >> viewInfos [

	^ self graphicModel viewInfos
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewGraphicModelLayer >> viewInfos: aViewInfos [

	self graphicModel viewInfos: aViewInfos
]
