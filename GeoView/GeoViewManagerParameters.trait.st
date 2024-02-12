"
I am the parameters of the GeoplotManager.
"
Trait {
	#name : #GeoViewManagerParameters,
	#traits : 'MolComponentParameters',
	#classTraits : 'MolComponentParameters classTrait',
	#category : #'GeoView-Core'
}

{ #category : #'parameters - event strategy' }
GeoViewManagerParameters >> addEventBehavior: aGeoViewEventBehavior [
]

{ #category : #'parameters - event strategy' }
GeoViewManagerParameters >> addEventBehaviorAtFirst: aGeoViewEventBehavior [
]

{ #category : #'parameters - event strategy' }
GeoViewManagerParameters >> deleteEventBehavior: aGeoViewEventBehavior [
]

{ #category : #'parameters - event strategy' }
GeoViewManagerParameters >> deleteEventBehaviors [
]

{ #category : #'parameters - event strategy' }
GeoViewManagerParameters >> getEventBehaviors [
]

{ #category : #'parameters - objects' }
GeoViewManagerParameters >> getObjectIndexAccessor [
]

{ #category : #'parameters - event strategy' }
GeoViewManagerParameters >> setEventBehaviors: anEventBehaviorList [
]

{ #category : #'parameters - objects' }
GeoViewManagerParameters >> setObjectIndexAccessor: aSymbol [
]

{ #category : #'parameters - selection manager' }
GeoViewManagerParameters >> setSelectionManager: aSmockSelectionManager [
	self deprecated:'not use, use setSelectionManagerName: aComponentName'.
]

{ #category : #'parameters - selection manager' }
GeoViewManagerParameters >> setSelectionManagerName: aComponentName [
	"Setup a selection manager"
]

{ #category : #'parameters - selection manager' }
GeoViewManagerParameters >> setSymbologyManagerName: aComponentName [
	"Setup a symbology manager"
]
