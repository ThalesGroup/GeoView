"
I am the parameters of the GeoplotManager.
"
Trait {
	#name : #GeoViewManagerParameters,
	#traits : 'MolComponentParameters',
	#classTraits : 'MolComponentParameters classTrait',
	#category : #'GeoView-Molecule-Contract'
}

{ #category : #'parameters - graphic projection' }
GeoViewManagerParameters >> getDisplayToGraphicProjection [
]

{ #category : #'parameters - interactions' }
GeoViewManagerParameters >> getInteractionsStrategy [
]

{ #category : #'parameters - objects' }
GeoViewManagerParameters >> getObjectIndexAccessor [
]

{ #category : #'parameters - view infos' }
GeoViewManagerParameters >> getViewInfos [
]

{ #category : #'parameters - graphic projection' }
GeoViewManagerParameters >> setDisplayToGraphicProjection: aGeoView2DProjection [
]

{ #category : #'parameters - interactions' }
GeoViewManagerParameters >> setInteractionsStrategy: aStrategy [
]

{ #category : #'parameters - objects' }
GeoViewManagerParameters >> setObjectIndexAccessor: aSymbol [
]

{ #category : #'parameters - selection manager' }
GeoViewManagerParameters >> setSelectionManagerName: aComponentName [
	"Setup a selection manager"
]

{ #category : #'parameters - selection manager' }
GeoViewManagerParameters >> setSymbologyManagerName: aComponentName [
	"Setup a symbology manager"
]

{ #category : #'parameters - view infos' }
GeoViewManagerParameters >> setViewInfos: aGeoViewInfos [
]
