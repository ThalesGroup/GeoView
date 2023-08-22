Trait {
	#name : #GeoViewPickingServices,
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #'GeoView-Picking'
}

{ #category : #'services - picking' }
GeoViewPickingServices >> pickAt: aGlobalPoint [
	"Return all geo objects under aPoint"
	^ self pickAt: aGlobalPoint radius: 0
]

{ #category : #'services - picking' }
GeoViewPickingServices >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"Return all geo objects under aPoint with a radius in pixels"
	^ self explicitRequirement
]
