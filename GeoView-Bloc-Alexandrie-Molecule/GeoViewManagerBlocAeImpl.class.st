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

{ #category : #initialization }
GeoViewManagerBlocAeImpl >> installEventHandlers: aBlElement [
	"do nothing"
]

{ #category : #'services - drawing' }
GeoViewManagerBlocAeImpl >> requestViewUpdate [

	self view requestRepaint
]
