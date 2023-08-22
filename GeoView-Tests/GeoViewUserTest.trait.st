Trait {
	#name : #GeoViewUserTest,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'GeoView-Tests-Utils'
}

{ #category : #'accessing - events' }
GeoViewUserTest classSide >> consumedComponentEvents [
<componentContract>	
	^{ GeoViewManagerEvents . GeoViewManagerLayerEvents  } 
]
