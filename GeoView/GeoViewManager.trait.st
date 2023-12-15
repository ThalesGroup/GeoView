"
I am the GeoplotManager.
I provide a geographical view.
"
Trait {
	#name : #GeoViewManager,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #'GeoView-Core'
}

{ #category : #'accessing - events' }
GeoViewManager classSide >> consumedComponentEvents [
	<componentContract>
	^ { SmockSelectionManagerEvents }
]

{ #category : #'accessing - events' }
GeoViewManager classSide >> producedComponentEvents [
<componentContract>		
	^{ GeoViewManagerEvents . GeoViewManagerLayerEvents . GeoViewManagerCursorEvents }
]

{ #category : #'accessing - parameters' }
GeoViewManager classSide >> providedComponentParameters [
<componentContract>		
	^{ GeoViewManagerParameters . GeoViewManagerGeoObjectsParameters }
]

{ #category : #'accessing - services' }
GeoViewManager classSide >> providedComponentServices [
<componentContract>	
	^{ GeoViewManagerServices. 
		GeoViewManagerLayerServices.
		GeoViewManagerGeoObjectsServices.
		GeoViewPickingServices } 
]

{ #category : #'accessing - services' }
GeoViewManager classSide >> usedComponentServices [
<componentContract>	
	^{MapProjectionManagerServices . SmockSymbologyManagerServices . SmockSelectionManagerServices }
]
