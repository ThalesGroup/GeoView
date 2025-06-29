"
I am the GeoplotManager.
I provide a geographical view.
"
Trait {
	#name : #GeoViewManager,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'GeoView-Molecule-Contract'
}

{ #category : #'accessing - events' }
GeoViewManager classSide >> consumedComponentEvents [

	<componentContract>
	^ {
		  SmockSelectionManagerEvents.
		  SmockSymbologyManagerEvents }
]

{ #category : #'accessing - events' }
GeoViewManager classSide >> producedComponentEvents [

	<componentContract>
	^ {
		  GeoViewManagerEvents.
		  GeoViewManagerCursorEvents }
]

{ #category : #'accessing - parameters' }
GeoViewManager classSide >> providedComponentParameters [

	<componentContract>
	^ {
		  GeoViewManagerParameters }
]

{ #category : #'accessing - services' }
GeoViewManager classSide >> providedComponentServices [

	<componentContract>
	^ {
		  GeoViewManagerServices.
		  GeoViewManagerObjectsServices.
		  GeoViewManagerPickingServices }
]

{ #category : #'accessing - services' }
GeoViewManager classSide >> usedComponentServices [

	<componentContract>
	^ {
		  SmockSelectionManagerServices.
		  SmockSymbologyManagerServices }
]
