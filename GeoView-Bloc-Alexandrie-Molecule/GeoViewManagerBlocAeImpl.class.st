Class {
	#name : #GeoViewManagerBlocAeImpl,
	#superclass : #GeoViewManagerImpl,
	#category : #'GeoView-Bloc-Alexandrie-Molecule'
}

{ #category : #'layer creation' }
GeoViewManagerBlocAeImpl >> createGeoObjectsLayer: aName [

	| layer |
	layer := GeoViewGeoObjectsLayer new.
	layer name: aName.
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

{ #category : #initialization }
GeoViewManagerBlocAeImpl >> installEventHandlers: aBlElement [

	"Layers events"
	aBlElement addEventHandlerOn: GeoViewLayerProcessDataChanged do: [ :e | self layerHasBeenUpdated: e ].
	aBlElement addEventHandlerOn: GeoViewLayerAddedEvent do: [ :e | self layerAdded: e ]. 
	aBlElement addEventHandlerOn: GeoViewLayerRemovedEvent do: [ :e | self layerRemoved: e ]. 
	
	"Projection events"
	aBlElement addEventHandlerOn: GeoViewMapProjectionChangedEvent do: [ :e | self mapProjectionHasChanged: e ]. 
		
	"Selection events"
	aBlElement addEventHandlerOn: GeoViewObjectSelectionChanged do: [ :e | self strategyRequestSetSelection: e objectList ].
	aBlElement addEventHandlerOn: GeoViewObjectSelectionAdded do: [ :e | self strategyRequestAddSelection: e objectList ].
	aBlElement addEventHandlerOn: GeoViewObjectSelectionCleared do: [ :e | self strategyRequestClearSelection ]
]

{ #category : #'services - drawing' }
GeoViewManagerBlocAeImpl >> requestViewUpdate [

	self view requestRepaint
]
