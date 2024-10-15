Trait {
	#name : #GeoViewManagerPickingServices,
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'GeoView-Molecule-Contract'
}

{ #category : #'services - picking' }
GeoViewManagerPickingServices >> pickAt: aGlobalPoint [
	"Return all objects under a global point"
]

{ #category : #'services - picking' }
GeoViewManagerPickingServices >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"Return all objects under a global point inside a radius in pixels"
]
