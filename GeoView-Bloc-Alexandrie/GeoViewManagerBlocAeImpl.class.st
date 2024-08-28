Class {
	#name : #GeoViewManagerBlocAeImpl,
	#superclass : #GeoViewManagerImpl,
	#category : #'GeoView-Bloc-Alexandrie-Core'
}

{ #category : #'layer creation' }
GeoViewManagerBlocAeImpl >> createLayer: aKey [

	| layer |
	layer := GeoViewUserToDisplayToGraphicLayer new.
	layer layerName: aKey.
	layer displayModel indexAccessor: self getObjectIndexAccessor.
	
	^ layer
]

{ #category : #initialization }
GeoViewManagerBlocAeImpl >> createView [

	| aeView |
	aeView := BlGeoViewAeElement new.
	aeView background: Color black.
	aeView displayToGraphicProjection: GeoView2DProjection new.
	self installEventHandlers: aeView.

	self view: aeView.
]

{ #category : #'projection center' }
GeoViewManagerBlocAeImpl >> getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint [

	| localPoint |
	localPoint := self getLocalPointFromGlobalPoint: aGlobalPoint.
	^ self getAbsoluteCoordinatesFromLocalPoint: localPoint
]

{ #category : #'projection center' }
GeoViewManagerBlocAeImpl >> getAbsoluteCoordinatesFromLocalPoint: aLocalPoint [

	| cartesianCoordinates absoluteCoordinates projection |
	projection := self getMapProjectionManagerServicesProvider getProjection.
	projection ifNil:[ ^ nil ].
		
	cartesianCoordinates := view displayToGraphicProjection projPixelToCart: aLocalPoint.
	absoluteCoordinates := projection projCartToLatLon: cartesianCoordinates.
	^ absoluteCoordinates
]

{ #category : #'projection center' }
GeoViewManagerBlocAeImpl >> getGlobalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	| localPoint |
	localPoint := self getLocalPointFromAbsoluteCoordinates:
		              anAbsoluteCoordinates.
	^ self getGlobalPointFromLocalPoint: localPoint
]

{ #category : #'projection center' }
GeoViewManagerBlocAeImpl >> getGlobalPointFromLocalPoint: aLocalPoint [

	aLocalPoint ifNil:[ ^ nil ].
	^ self view localPointToGlobal: aLocalPoint
]

{ #category : #'projection center' }
GeoViewManagerBlocAeImpl >> getLocalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	| projection |
	projection := self getMapProjectionManagerServicesProvider getProjection.
	projection ifNil:[ ^ nil ].
	
	^ self view displayToGraphicProjection projCartToPixel:
		  (projection projLatLonToCart: anAbsoluteCoordinates)
]

{ #category : #'projection center' }
GeoViewManagerBlocAeImpl >> getLocalPointFromGlobalPoint: aGlobalPoint [

	^ self view globalPointToLocal: aGlobalPoint
]

{ #category : #initialization }
GeoViewManagerBlocAeImpl >> handleExtentChangedEvent: anEvent [

	self viewExtentHasChanged: anEvent source extent
]

{ #category : #initialization }
GeoViewManagerBlocAeImpl >> initializeInputContext [

	super initializeInputContext.
	inputContext addStrategy: GeoViewNavigationBlocStrategy new.
	inputContext addStrategy: GeoViewCursorInformationBlocStrategy new.
]

{ #category : #initialization }
GeoViewManagerBlocAeImpl >> installEventHandlers: aBlElement [
	"Properties events"

	aBlElement addEventHandler: (BlEventHandler
			 on: BlElementExtentChangedEvent
			 do: [ :e | self handleExtentChangedEvent: e ]).

	"Interaction events"
	aBlElement addEventHandler: (BlEventHandler
			 on: BlUIEvent
			 do: [ :e | self handleUIEvent: e ])
]

{ #category : #initialization }
GeoViewManagerBlocAeImpl >> pickAt: aGlobalPoint radius: aRadiusInPixels [

	"prepare the picking result"
	| pickingResult distanceBlock radius |
	pickingResult := (super pickAt: aGlobalPoint radius: aRadiusInPixels) ifNil:[ ^ nil ].

	"labordep: prepare to be setup with others blocks"
	distanceBlock := [ :gShape :point | gShape distanceTo: point ].
	radius := aRadiusInPixels ifNil:[ 0 ].

	"Collect all picked elements"
	self getLayers do:[ :l | 
		l graphicModel datas keysAndValuesDo:[ :key :gShape | | distanceInPixels pickingElement |
			
			"Way to detect if the gShape is picked"
			distanceInPixels := distanceBlock value: gShape value: pickingResult localPoint.
			distanceInPixels <= radius ifTrue:[

				"Store the element into the result"				
				pickingElement := GeoViewPickingElement new.
				pickingElement layerName: l layerName.
				pickingElement layerLevel: nil. self flag:'labordep: mettre le level'.
				pickingElement distanceInPixels: distanceInPixels.
				pickingElement objectKey: key.
				pickingElement dShape: (l displayModel getData: key).
				pickingElement gShape: gShape.
				
				pickingResult addPickingElement: pickingElement.
				
			].			
		].
	].

	pickingResult applyOrder: [ :a :b | a distanceInPixels < b distanceInPixels ].
	^ pickingResult
]

{ #category : #'services - drawing' }
GeoViewManagerBlocAeImpl >> requestViewUpdate [

	self view requestRepaint
]

{ #category : #'projection center' }
GeoViewManagerBlocAeImpl >> setGeoCenter: anAbsoluteCoordinates [
	| cartesianCoordinates |
	super setGeoCenter: anAbsoluteCoordinates.
	cartesianCoordinates := self getMapProjectionManagerServicesProvider getProjection projLatLonToCart: self geoCenter.
	
	self view displayToGraphicProjection cartesianCenter: cartesianCoordinates.
	self view updateGraphicModel.
]

{ #category : #scale }
GeoViewManagerBlocAeImpl >> setScaleInMeters: aNumber [

	super setScaleInMeters: aNumber.
	self view displayToGraphicProjection altitudeInMeters: self scaleInMeters.
	self view displayToGraphicProjection updateResolution: self view getBounds extent.
	self view updateGraphicModel
]

{ #category : #'private - events' }
GeoViewManagerBlocAeImpl >> viewExtentHasChanged: anExtent [

	anExtent ifNil:[ ^ self ].

	"configure view projection"
	self view displayToGraphicProjection offsetInPixels: anExtent / 2.
	self view displayToGraphicProjection updateResolution: anExtent.

	self view updateGraphicModel
]
