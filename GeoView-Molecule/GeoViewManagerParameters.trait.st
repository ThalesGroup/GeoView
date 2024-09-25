"
I am the parameters of the GeoplotManager.
"
Trait {
	#name : #GeoViewManagerParameters,
	#traits : 'MolComponentParameters',
	#classTraits : 'MolComponentParameters classTrait',
	#category : #'GeoView-Molecule'
}

{ #category : #'parameters - graphic projection' }
GeoViewManagerParameters >> getDisplayToGraphicProjection [

	^ self getView displayToGraphicProjection
]

{ #category : #'parameters - objects' }
GeoViewManagerParameters >> getObjectIndexAccessor [

	^ self view objectIndexAccessor
]

{ #category : #'parameters - graphic projection' }
GeoViewManagerParameters >> setDisplayToGraphicProjection: aGeoView2DProjection [

	self getView displayToGraphicProjection: aGeoView2DProjection
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
