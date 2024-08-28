Trait {
	#name : #GeoViewManagerPickingServices,
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'GeoView-Molecule'
}

{ #category : #'services - picking' }
GeoViewManagerPickingServices >> pickAt: aGlobalPoint [
	"Return all objects under a global point"

	^ self pickAt: aGlobalPoint radius: 0
]

{ #category : #'services - picking' }
GeoViewManagerPickingServices >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"Return all objects under a global point inside a radius in pixels"
]
