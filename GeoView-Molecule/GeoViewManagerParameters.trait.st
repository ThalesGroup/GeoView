"
I am the parameters of the GeoplotManager.
"
Trait {
	#name : #GeoViewManagerParameters,
	#traits : 'MolComponentParameters',
	#classTraits : 'MolComponentParameters classTrait',
	#category : #'GeoView-Molecule'
}

{ #category : #'parameters - objects' }
GeoViewManagerParameters >> getObjectIndexAccessor [

	^ self getView objectIndexAccessor
]

{ #category : #'parameters - objects' }
GeoViewManagerParameters >> setObjectIndexAccessor: aSymbol [

	self getView objectIndexAccessor: aSymbol
]

{ #category : #'parameters - selection manager' }
GeoViewManagerParameters >> setSelectionManagerName: aComponentName [
	"Setup a selection manager"
]

{ #category : #'parameters - selection manager' }
GeoViewManagerParameters >> setSymbologyManagerName: aComponentName [
	"Setup a symbology manager"
]
