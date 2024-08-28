"
I am a BlElement which display a GeoViewWidget using Alexandrie backend drawing.
"
Class {
	#name : #BlGeoViewAeElement,
	#superclass : #BlAbstractGeoViewElement,
	#category : #'GeoView-Bloc-Alexandrie-Core'
}

{ #category : #'API -- layers management' }
BlGeoViewAeElement >> addLayer: aLayer [
	
	(self layers includes: aLayer) ifTrue: [ ^ self ].
	self configureLayer: aLayer.
	self layers add: aLayer
]

{ #category : #'API -- objects management' }
BlGeoViewAeElement >> addObject: anUserObject [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e addObject: anUserObject ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlGeoViewAeElement >> addObjects: anUserObjectList [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e addObjects: anUserObjectList ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #drawing }
BlGeoViewAeElement >> aeDrawOn: aeCanvas [
	"drawing native bloc elements"

	| sort |
	super aeDrawOn: aeCanvas.
	
	sort := self isMarkedForSortDatas.
	self layers do: [ :l |
		sort ifTrue: [ l sortDatas ].
		l aeDrawOn: aeCanvas ].

	isMarkedForSortDatas := false
]

{ #category : #private }
BlGeoViewAeElement >> configureLayer: aLayer [
	
	"Setup the 2D projection of the layer"
	aLayer graphicModel projection: self displayToGraphicProjection.
	
	"add alexandrie process datas"
	aLayer graphicModel setProcessData: DCompositeShapeGeoViewProcessData new for: SmockDCompositeShape.
	aLayer graphicModel setProcessData: DSymbolGeoViewProcessData new for: SmockDSymbol.
	aLayer graphicModel setProcessData: DCircleGeoViewProcessData new for: SmockDCircle.
	aLayer graphicModel setProcessData: DTextGeoViewProcessData new for: SmockDText.
	aLayer graphicModel setProcessData: DPolygonGeoViewProcessData new for: SmockDPolygon.
	aLayer graphicModel setProcessData: DPolylineGeoViewProcessData new for: SmockDPolyline.

	"aLayer displayToGraphicModel defaultProcessData: DShapeAeProcessData new."
]

{ #category : #'API -- size' }
BlGeoViewAeElement >> getBounds [

	^ self bounds
]

{ #category : #'API -- size' }
BlGeoViewAeElement >> getExtent [
	
	^ self extent
]

{ #category : #'API -- layers management' }
BlGeoViewAeElement >> getLayer: aKey [
	self explicitRequirement
]

{ #category : #'API -- layers management' }
BlGeoViewAeElement >> getLayers [
	
	^ self layers
]

{ #category : #'API -- objects management' }
BlGeoViewAeElement >> haveObjectIndex: anIndex [
	"Pay attention before using it because graphical model is out of sync real user model due to usage of BlTask (asynchronous)"

	^ self layers anySatisfy: [ :l | l haveObjectIndex: anIndex ]
]

{ #category : #accessing }
BlGeoViewAeElement >> isMarkedForSortDatas [

	^ isMarkedForSortDatas ifNil: [ isMarkedForSortDatas := false ]
]

{ #category : #'API -- layers management' }
BlGeoViewAeElement >> removeLayer: aLayer [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
BlGeoViewAeElement >> removeObject: anUserObject [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e removeObject: anUserObject ].
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlGeoViewAeElement >> removeObjects: anUserObjectList [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e removeObjects: anUserObjectList ].
		self requestRepaint ]
]

{ #category : #private }
BlGeoViewAeElement >> requestSortDatas [

	isMarkedForSortDatas := true.
]

{ #category : #'API -- selection' }
BlGeoViewAeElement >> selectedObjectIndexes: anIndexList [

	self enqueueBlockAsTask: [
		self layers do: [ :l | l updateState: #selected withIndexes: anIndexList ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlGeoViewAeElement >> updateObject: anUserObject [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e updateObject: anUserObject ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlGeoViewAeElement >> updateObjects: anUserObjectList [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e updateObjects: anUserObjectList ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #private }
BlGeoViewAeElement >> updateState: aStateSymbol withIndexes: aKeyList [
	
	self enqueueBlockAsTask: [ 
		self layers do: [ :l | l updateState: aStateSymbol withIndexes: aKeyList ].
		self requestSortDatas.
		self requestRepaint
	]
]
