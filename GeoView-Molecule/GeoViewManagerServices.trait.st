"
I define services of GeoplotManager
"
Trait {
	#name : #GeoViewManagerServices,
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'GeoView-Molecule-Contract'
}

{ #category : #'services - layer' }
GeoViewManagerServices >> addLayer: aLayer [
]

{ #category : #services }
GeoViewManagerServices >> centerOnPoint: aGlobalPoint [ 
]

{ #category : #'services - layer' }
GeoViewManagerServices >> createAndAddGeoObjectsLayer: aKey [
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

{ #category : #'services - layer' }
GeoViewManagerServices >> getLayer: aKey [
]

{ #category : #'services - layer' }
GeoViewManagerServices >> getLayerLevel: aKey [
]

{ #category : #'services - layer' }
GeoViewManagerServices >> getLayers [
]

{ #category : #services }
GeoViewManagerServices >> getLocalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [
]

{ #category : #services }
GeoViewManagerServices >> getLocalPointFromGlobalPoint: aGlobalPoint [
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

{ #category : #'services - layer' }
GeoViewManagerServices >> removeAllLayers [
]

{ #category : #'services - layer' }
GeoViewManagerServices >> removeLayer: aKey [
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

{ #category : #'services - layer' }
GeoViewManagerServices >> setLevel: anInteger forLayer: aKey [
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
