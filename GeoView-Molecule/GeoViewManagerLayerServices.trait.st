"
I am layer services for Geoplot.
"
Trait {
	#name : #GeoViewManagerLayerServices,
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'GeoView-Molecule-Core'
}

{ #category : #'services - layer creation' }
GeoViewManagerLayerServices >> addLayer: aLayer [
]

{ #category : #'services - layer creation' }
GeoViewManagerLayerServices >> createAndAddGeoObjectLayer: aKey [
	self deprecated:'use createAndAddLayer:'.
]

{ #category : #'services - layer creation' }
GeoViewManagerLayerServices >> createAndAddGeoObjectLayer: aKey level: anInteger [ 
	self deprecated:'use createAndAddLayer: and setLevel:forLayer:'.
]

{ #category : #'services - layer creation' }
GeoViewManagerLayerServices >> createAndAddLayer: aKey [
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

{ #category : #'services - layer deletion' }
GeoViewManagerLayerServices >> removeAllLayers [
]

{ #category : #'services - layer deletion' }
GeoViewManagerLayerServices >> removeLayer: aKey [
]

{ #category : #'services - layer configuration' }
GeoViewManagerLayerServices >> setLevel: anInteger forLayer: aKey [
]
