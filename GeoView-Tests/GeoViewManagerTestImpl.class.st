Class {
	#name : #GeoViewManagerTestImpl,
	#superclass : #GeoViewManagerImpl,
	#category : #'GeoView-Tests-Utils'
}

{ #category : #'layer creation' }
GeoViewManagerTestImpl >> createLayer: aKey [

	^ GeoViewObjectTestLayer new
]

{ #category : #initialization }
GeoViewManagerTestImpl >> createView [

	self view: GeoViewTest new
]
