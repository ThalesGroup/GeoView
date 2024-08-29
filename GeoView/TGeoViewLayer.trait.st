"
I am Geoplot layer.
"
Trait {
	#name : #TGeoViewLayer,
	#instVars : [
		'isVisible',
		'layerName',
		'processDataChangedBlock'
	],
	#traits : 'TGeoViewHandleObjects',
	#classTraits : 'TGeoViewHandleObjects classTrait',
	#category : #'GeoView-Core'
}

{ #category : #'API -- process datas' }
TGeoViewLayer >> getAllProcessData [
	self explicitRequirement
]

{ #category : #'API -- process datas' }
TGeoViewLayer >> getProcessDataFor: aGeoObjectClass [
	self explicitRequirement
]

{ #category : #'API -- drawing' }
TGeoViewLayer >> isVisible [

	^ isVisible ifNil:[ isVisible := true ]
]

{ #category : #'API -- drawing' }
TGeoViewLayer >> isVisible: aBoolean [

	isVisible := false
]

{ #category : #accessing }
TGeoViewLayer >> layerName [

	^ layerName
]

{ #category : #accessing }
TGeoViewLayer >> layerName: anObject [

	layerName := anObject
]

{ #category : #private }
TGeoViewLayer >> processDatasChanged [
	
	processDataChangedBlock ifNotNil:[ :e | e value: self ]
]

{ #category : #accessing }
TGeoViewLayer >> projection: aProjection [

	self deprecated: 'not used internaly'.
	self explicitRequirement
	
]

{ #category : #'API -- process datas' }
TGeoViewLayer >> removeProcessDataFor: aGeoObjectClass [
	self explicitRequirement
]

{ #category : #'API -- process datas' }
TGeoViewLayer >> setDefaultProcessData: aDataProcessor [
	self explicitRequirement
]

{ #category : #'API -- process datas' }
TGeoViewLayer >> setProcessData: aProcessData for: aGeoObjectClass [
	self explicitRequirement
	
]

{ #category : #accessing }
TGeoViewLayer >> symbologyProvider: aSymbologyProvider [
	self explicitRequirement
]

{ #category : #'API -- drawing' }
TGeoViewLayer >> updateGraphicModel [
	self explicitRequirement
]

{ #category : #'API -- process datas' }
TGeoViewLayer >> whenProcessDatasChangedDo: aBlock [

	processDataChangedBlock := aBlock
]
