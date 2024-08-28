"
I define services of GeoplotManager
"
Trait {
	#name : #GeoViewManagerServices,
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'GeoView-Molecule'
}

{ #category : #services }
GeoViewManagerServices >> centerOnPoint: aGlobalPoint [ 
]

{ #category : #services }
GeoViewManagerServices >> getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint [
]

{ #category : #services }
GeoViewManagerServices >> getAbsoluteCoordinatesFromLocalPoint: aLocalPoint [
]

{ #category : #services }
GeoViewManagerServices >> getGeoCenter [ 
]

{ #category : #services }
GeoViewManagerServices >> getGlobalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [
]

{ #category : #services }
GeoViewManagerServices >> getGlobalPointFromLocalPoint: aLocalPoint [
]

{ #category : #services }
GeoViewManagerServices >> getLocalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [
]

{ #category : #services }
GeoViewManagerServices >> getLocalPointFromGlobalPoint: aGlobalPoint [
]

{ #category : #services }
GeoViewManagerServices >> getScaleFactor [
]

{ #category : #services }
GeoViewManagerServices >> getScaleInMeters [
]

{ #category : #services }
GeoViewManagerServices >> getView [
]

{ #category : #'services - drawing' }
GeoViewManagerServices >> requestViewUpdate [
]

{ #category : #services }
GeoViewManagerServices >> scaleDown [
]

{ #category : #services }
GeoViewManagerServices >> scaleUp [
]

{ #category : #services }
GeoViewManagerServices >> setGeoCenter: anAbsoluteCoordinates [
]

{ #category : #services }
GeoViewManagerServices >> setScaleFactor: aNumber [
]

{ #category : #services }
GeoViewManagerServices >> setScaleInMeters: aNumber [
]

{ #category : #services }
GeoViewManagerServices >> setViewBoundsFrom: aPoint1 to: aPoint2 [
	"Force the view displayed bounds. Recompute View Center and Scale Factor"
	self deprecated:'the size is delegated to the backend'.
]
