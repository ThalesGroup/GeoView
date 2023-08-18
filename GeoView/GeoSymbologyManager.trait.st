Trait {
	#name : #GeoSymbologyManager,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'GeoView-Symbology'
}

{ #category : #'accessing - events' }
GeoSymbologyManager classSide >> producedComponentEvents [
<componentContract>		
	^{ GeoSymbologyManagerEvents }
]

{ #category : #'accessing - services' }
GeoSymbologyManager classSide >> providedComponentServices [
<componentContract>	
	^{ GeoSymbologyManagerServices } 
]
