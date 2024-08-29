Class {
	#name : #GeoViewManagerBlocAeImpl,
	#superclass : #GeoViewManagerImpl,
	#category : #'GeoView-Bloc-Alexandrie-Molecule'
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

	| element |
	element := BlGeoViewAeElement new.
	self installEventHandlers: element.

	self view: element.
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
GeoViewManagerBlocAeImpl >> installEventHandlers: aBlElement [
	"Properties events"

	"aBlElement addEventHandler: (BlEventHandler
			 on: BlElementExtentChangedEvent
			 do: [ :e | self handleExtentChangedEvent: e ])."

	"Interaction events"
	"aBlElement addEventHandler: (BlEventHandler
			 on: BlUIEvent
			 do: [ :e | self handleUIEvent: e ])"
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
