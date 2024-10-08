Class {
	#name : #GeoViewManagerTestImpl,
	#superclass : #GeoViewManagerImpl,
	#category : #'GeoView-Molecule-Tests-Utils'
}

{ #category : #deprecation }
GeoViewManagerTestImpl class >> isDeprecated [
	^ true
]

{ #category : #'layer creation' }
GeoViewManagerTestImpl >> createGeoObjectsLayer: aName [

	^ GeoViewObjectTestLayer new
]

{ #category : #initialization }
GeoViewManagerTestImpl >> createView [

	self view: GeoViewTestWidget new
]

{ #category : #'services - map projection' }
GeoViewManagerTestImpl >> getMapProjection [
]
