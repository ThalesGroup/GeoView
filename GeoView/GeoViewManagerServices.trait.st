"
I define services of GeoplotManager
"
Trait {
	#name : #GeoViewManagerServices,
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'GeoView-Core'
}

{ #category : #'projection center' }
GeoViewManagerServices >> centerOnPoint: aGlobalPoint [ 
]

{ #category : #'projection center' }
GeoViewManagerServices >> getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint [
]

{ #category : #'projection center' }
GeoViewManagerServices >> getAbsoluteCoordinatesFromLocalPoint: aLocalPoint [
]

{ #category : #'projection center' }
GeoViewManagerServices >> getGeoCenter [ 
]

{ #category : #'projection center' }
GeoViewManagerServices >> getGlobalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [
]

{ #category : #'projection center' }
GeoViewManagerServices >> getGlobalPointFromLocalPoint: aLocalPoint [
]

{ #category : #'projection center' }
GeoViewManagerServices >> getLocalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [
]

{ #category : #'projection center' }
GeoViewManagerServices >> getLocalPointFromGlobalPoint: aGlobalPoint [
]

{ #category : #scale }
GeoViewManagerServices >> getScaleFactor [
]

{ #category : #scale }
GeoViewManagerServices >> getScaleInMeters [
]

{ #category : #accessing }
GeoViewManagerServices >> getView [
]

{ #category : #scale }
GeoViewManagerServices >> scaleDown [
]

{ #category : #scale }
GeoViewManagerServices >> scaleUp [
]

{ #category : #'projection center' }
GeoViewManagerServices >> setGeoCenter: anAbsoluteCoordinates [
]

{ #category : #scale }
GeoViewManagerServices >> setScaleFactor: aNumber [
]

{ #category : #scale }
GeoViewManagerServices >> setScaleInMeters: aNumber [
]

{ #category : #size }
GeoViewManagerServices >> setViewBoundsFrom: aPoint1 to: aPoint2 [
	"Force the view displayed bounds. Recompute View Center and Scale Factor"
	self deprecated:'the size is delegated to the backend'.
]
