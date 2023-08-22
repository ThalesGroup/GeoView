"
I am the Bloc implementation for the GeoplotManager.
"
Class {
	#name : #GeoViewManagerBlocImpl,
	#superclass : #GeoViewManagerImpl,
	#category : #'GeoView-Bloc-Core-Impl'
}

{ #category : #initialize }
GeoViewManagerBlocImpl >> componentInitialize [ 

	super componentInitialize.
	
	"Default Behavior"
	self addEventBehavior: (GeoViewBlocCursorInformationsBehavior new).
	self addEventBehavior: (GeoViewBlocPickingBehavior new).
	self addEventBehavior: (GeoViewBlocMapNavigationBehavior new).
]

{ #category : #initialize }
GeoViewManagerBlocImpl >> createGeoObjectLayer: aLayerKey [
	| layer |
	layer := BlGeoViewObjectLayer new.
	layer layerName: aLayerKey.
	layer size: self view extent.
	layer displayProjectionModel indexAccessor: self geoObjectsIndexAccessor.
	^ layer
]

{ #category : #initialize }
GeoViewManagerBlocImpl >> createView [
	| blGeoView |
	blGeoView := BlGeoView new.
	blGeoView background: Color darkGray.
	
	self initializeViewEventHandlers: blGeoView.
	self view: blGeoView.
]

{ #category : #initialize }
GeoViewManagerBlocImpl >> getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint [
	| localPoint |
	localPoint := self getLocalPointFromGlobalPoint: aGlobalPoint.
	^self getAbsoluteCoordinatesFromLocalPoint: localPoint
]

{ #category : #initialize }
GeoViewManagerBlocImpl >> getAbsoluteCoordinatesFromLocalPoint: aLocalPoint [
	| cartesianCoordinates absoluteCoordinates projection |
	projection := self getMapProjectionManagerServicesProvider getProjection.
	cartesianCoordinates := view displayToGraphicProjection projPixelToCart: aLocalPoint.
	absoluteCoordinates := projection projCartToLatLon: cartesianCoordinates.
	^absoluteCoordinates
]

{ #category : #initialize }
GeoViewManagerBlocImpl >> getGlobalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [
	| localPoint |
	localPoint := self getLocalPointFromAbsoluteCoordinates: anAbsoluteCoordinates.
	^self getGlobalPointFromLocalPoint: localPoint.
]

{ #category : #initialize }
GeoViewManagerBlocImpl >> getGlobalPointFromLocalPoint: aLocalPoint [
	^view localPointToGlobal: aLocalPoint.
]

{ #category : #initialize }
GeoViewManagerBlocImpl >> getLocalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [
	| projection |
	projection := self getMapProjectionManagerServicesProvider getProjection.
	^view displayToGraphicProjection projCartToPixel: (projection projLatLonToCart: anAbsoluteCoordinates)
]

{ #category : #initialize }
GeoViewManagerBlocImpl >> getLocalPointFromGlobalPoint: aGlobalPoint [
	 ^view globalPointToLocal: aGlobalPoint
]

{ #category : #'events handling' }
GeoViewManagerBlocImpl >> initializeViewEventHandlers: aBlGeoView [
	"wrap bloc event to penfeld event"
	
	"mouse events"
	"aBlGeoView when: BlMouseEnterEvent  do:[ :e | self executeCallback: (PenMouseEvent fromBloc: e) ].
	aBlGeoView when: BlMouseLeaveEvent do:[ :e | self executeCallback: (PenMouseEvent fromBloc: e) ]."
	"aBlGeoView when: BlMouseMiddleButton do:[ :e | self executeCallback: (PenMouseEvent fromBloc: e) ]."
	aBlGeoView when: BlMouseMoveEvent do:[ :e | self dispatchEvent: e ].
	aBlGeoView when: BlClickEvent do:[ :e | self dispatchEvent: e ].
	aBlGeoView when: BlMouseWheelEvent do:[ :e | self dispatchEvent: e ].
	aBlGeoView when: BlMouseDownEvent do:[ :e | self dispatchEvent: e ].
	aBlGeoView when: BlMouseUpEvent do:[ :e | self dispatchEvent: e ].
	
	"keyboard events"
	"aBlGeoView when: BlKeyboardEvent do:[ :e | self executeCallback: (PenKeyboardEvent fromBloc: e) ]."
	aBlGeoView when: BlKeyDownEvent do:[ :e | self dispatchEvent: e ].
	aBlGeoView when: BlKeyUpEvent do:[ :e | self dispatchEvent: e ].
]

{ #category : #scale }
GeoViewManagerBlocImpl >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"Return all geo objects under aPoint with a radius in pixels"
	| pickingResult |
	pickingResult := super pickAt: aGlobalPoint radius: aRadiusInPixels.
	pickingResult localPoint: (self view globalPointToLocal: aGlobalPoint).
	
	"Collect all picking elements"
	self getLayers do:[ :layer |
		layer isGeoObjectLayer ifTrue:[
			layer graphicProjectionModel datas keysAndValuesDo:[ :geoObjectKey :blElement | 
				self flag:'PLA :code provisoire de detection de la proximité'.
				(blElement containsGlobalPoint: aGlobalPoint) ifTrue:[ | pickingElement |
					pickingElement := GeoViewPickingElement new.
					pickingElement layerName: layer layerName.
					pickingElement layerLevel: nil. "PLA : a faire"
					pickingElement distanceInPixels: 0.
					pickingElement geoObjectKey: geoObjectKey.
					pickingElement dShape: (layer displayProjectionModel datas at: geoObjectKey).
					pickingElement gShape: blElement.
					pickingResult addPickingElement: pickingElement.
				].
			].
		].
	].

	^ pickingResult 
]

{ #category : #'projection center' }
GeoViewManagerBlocImpl >> setGeoCenter: anAbsoluteCoordinates [
	| cartesianCoordinates |
	super setGeoCenter: anAbsoluteCoordinates.
	cartesianCoordinates := self getMapProjectionManagerServicesProvider getProjection projLatLonToCart: self geoCenter.
	self view displayToGraphicProjection cartesianCenter: cartesianCoordinates.
	self view updateModelToView.
]

{ #category : #scale }
GeoViewManagerBlocImpl >> setScaleInMeters: aNumber [
	super setScaleInMeters: aNumber.
	self view displayToGraphicProjection altitudeInMeters: self scaleInMeters.
	self view displayToGraphicProjection updateResolution: self view getViewSize.
	self view updateModelToView.
]
