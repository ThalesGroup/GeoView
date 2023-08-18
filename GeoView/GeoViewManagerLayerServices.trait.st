"
I am layer services for Geoplot.
"
Trait {
	#name : #GeoViewManagerLayerServices,
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'GeoView-Core'
}

{ #category : #'services - layer creation' }
GeoViewManagerLayerServices >> addLayer: aLayer [
]

{ #category : #'services - layer creation' }
GeoViewManagerLayerServices >> createAndAddGeoObjectLayer: aKey [
]

{ #category : #'services - layer creation' }
GeoViewManagerLayerServices >> createAndAddGeoObjectLayer: aKey level: anInteger [ 
]

{ #category : #'services - layer deletion' }
GeoViewManagerLayerServices >> deleteAllLayers [
]

{ #category : #'services - layer deletion' }
GeoViewManagerLayerServices >> deleteLayer: aKey [
]

{ #category : #'services - layer accessing' }
GeoViewManagerLayerServices >> getLayer: aKey [
]

{ #category : #'services - layer configuration' }
GeoViewManagerLayerServices >> getLayerLevel: aKey [
]

{ #category : #'services - layer accessing' }
GeoViewManagerLayerServices >> getLayers [
]

{ #category : #'services - layer configuration' }
GeoViewManagerLayerServices >> setLevel: anInteger forLayer: aKey [
]
