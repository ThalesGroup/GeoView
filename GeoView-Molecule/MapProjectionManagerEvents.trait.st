"
I am the ProjectionManager Events.
"
Trait {
	#name : #MapProjectionManagerEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #'GeoView-Molecule'
}

{ #category : #deprecation }
MapProjectionManagerEvents classSide >> isDeprecated [
	^ true
]

{ #category : #projection }
MapProjectionManagerEvents >> projectionHasChanged: aProjection [
]

{ #category : #projection }
MapProjectionManagerEvents >> projectionUpdated: aProjection [
]
