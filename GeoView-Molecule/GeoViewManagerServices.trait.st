"
I define services of GeoplotManager
"
Trait {
	#name : #GeoViewManagerServices,
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'GeoView-Molecule-Core'
}

{ #category : #services }
GeoViewManagerServices >> centerOnPoint: aGlobalPoint [ 
]

{ #category : #services }
GeoViewManagerServices >> getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint [

	^ self getView absoluteCoordinatesFromGlobalPoint: aGlobalPoint 
]

{ #category : #services }
GeoViewManagerServices >> getAbsoluteCoordinatesFromLocalPoint: aLocalPoint [

	^ self getView absoluteCoordinatesFromLocalPoint: aLocalPoint 
]

{ #category : #services }
GeoViewManagerServices >> getGeoCenter [ 

	^ self getView geoCenter
]

{ #category : #services }
GeoViewManagerServices >> getGlobalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	^ self getView globalPointFromAbsoluteCoordinates: anAbsoluteCoordinates
]

{ #category : #services }
GeoViewManagerServices >> getGlobalPointFromLocalPoint: aLocalPoint [

	^ self getView globalPointFromLocalPoint: aLocalPoint
]

{ #category : #services }
GeoViewManagerServices >> getLocalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	^ self getView localPointFromAbsoluteCoordinates: anAbsoluteCoordinates
]

{ #category : #services }
GeoViewManagerServices >> getLocalPointFromGlobalPoint: aGlobalPoint [

	^ self getView localPointFromGlobalPoint: aGlobalPoint
]

{ #category : #'services - map projection' }
GeoViewManagerServices >> getMapProjection [
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

{ #category : #'services - map projection' }
GeoViewManagerServices >> setMapProjection: aMapProjection [
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
