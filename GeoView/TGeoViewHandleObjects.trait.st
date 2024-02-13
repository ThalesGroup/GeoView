Trait {
	#name : #TGeoViewHandleObjects,
	#category : #'GeoView-View'
}

{ #category : #'API -- objects management' }
TGeoViewHandleObjects >> addObject: aObject [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoViewHandleObjects >> addObjects: anObjectList [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoViewHandleObjects >> haveObjectIndex: anIndex [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoViewHandleObjects >> removeObject: aObject [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoViewHandleObjects >> removeObjects: anObjectList [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoViewHandleObjects >> updateObject: aObject [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoViewHandleObjects >> updateObjects: anObjectList [
	self explicitRequirement
]
