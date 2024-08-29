Trait {
	#name : #GeoViewUserTest,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'GeoView-Molecule-Tests-Utils'
}

{ #category : #'accessing - events' }
GeoViewUserTest classSide >> consumedComponentEvents [
<componentContract>	
	^{ GeoViewManagerEvents . GeoViewManagerLayerEvents  } 
]
