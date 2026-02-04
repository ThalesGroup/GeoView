"
I am geoplot manager events
"
Trait {
	#name : #GeoViewManagerEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #'GeoView-Molecule-Contract'
}

{ #category : #'events - view' }
GeoViewManagerEvents >> geoViewCenterHasChanged: anAbsoluteCoordinates in: aGeoViewManagerKey [
]

{ #category : #'events - layer' }
GeoViewManagerEvents >> geoViewLayerAdded: aKey in: aGeoViewManagerKey [
]

{ #category : #'events - layer' }
GeoViewManagerEvents >> geoViewLayerRemoved: aKey in: aGeoViewManagerKey [
]

{ #category : #'events - layer' }
GeoViewManagerEvents >> geoViewLayerUpdated: aKey in: aGeoViewManagerKey [
]

{ #category : #'events - view' }
GeoViewManagerEvents >> geoViewScaleHasChanged: aScale in: aGeoViewManagerKey [
]

{ #category : #'events - map projection' }
GeoViewManagerEvents >> mapProjectionHasChanged: aMapProjection in: aGeoViewManagerKey [
]
