"
I am Geoplot layer.
"
Trait {
	#name : #TGeoViewLayer,
	#category : #'GeoView-View & Layer'
}

{ #category : #'process data' }
TGeoViewLayer >> getAllProcessData [
	self explicitRequirement
]

{ #category : #'process data' }
TGeoViewLayer >> getProcessDataFor: aGeoObjectClass [
	self explicitRequirement
]

{ #category : #accessing }
TGeoViewLayer >> layerName [
	self explicitRequirement
]

{ #category : #testing }
TGeoViewLayer >> mapProjection: aProjection [
	self explicitRequirement
]

{ #category : #'process data' }
TGeoViewLayer >> removeProcessDataFor: aGeoObjectClass [
	self explicitRequirement
]

{ #category : #'process data' }
TGeoViewLayer >> setDefaultProcessData: aDataProcessor [
	self explicitRequirement
]

{ #category : #'process data' }
TGeoViewLayer >> setProcessData: aProcessData for: aGeoObjectClass [
	self explicitRequirement
	
]

{ #category : #testing }
TGeoViewLayer >> symbologyProvider: aSymbologyProvider [
	self explicitRequirement
]

{ #category : #private }
TGeoViewLayer >> updateGraphicModel [
	self explicitRequirement
]

{ #category : #private }
TGeoViewLayer >> whenProcessDatasChangedDo: aBlock [

	processDataChangedBlock := aBlock
]
