Class {
	#name : #GeoViewManagerBlocAeImpl,
	#superclass : #GeoViewManagerImpl,
	#category : #'GeoView-Bloc-Alexandrie-Molecule'
}

{ #category : #'layer creation' }
GeoViewManagerBlocAeImpl >> createGeoObjectsLayer: aKey [

	| layer |
	layer := GeoViewGeoObjectsLayer new.
	layer name: aKey.
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
	
	aBlElement addEventHandlerOn: GeoViewLayerProcessDataChanged do: [ :e | self layerHasBeenUpdated: e layerName ]
]

{ #category : #'services - drawing' }
GeoViewManagerBlocAeImpl >> requestViewUpdate [

	self view requestRepaint
]
