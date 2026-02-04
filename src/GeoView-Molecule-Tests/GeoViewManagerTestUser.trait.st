Trait {
	#name : #GeoViewManagerTestUser,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'GeoView-Molecule-Tests-Utils'
}

{ #category : #'accessing - events' }
GeoViewManagerTestUser classSide >> consumedComponentEvents [

	<componentContract>
	^ {
		  GeoViewManagerEvents.
		  GeoViewManagerCursorEvents }
]

{ #category : #'accessing - parameters' }
GeoViewManagerTestUser classSide >> usedComponentParameters [

	<componentContract>
	^ { GeoViewManagerParameters }
]

{ #category : #'accessing - services' }
GeoViewManagerTestUser classSide >> usedComponentServices [

	<componentContract>
	^ {
		  GeoViewManagerServices.
		  GeoViewManagerObjectsServices.
		  GeoViewManagerPickingServices }
]
