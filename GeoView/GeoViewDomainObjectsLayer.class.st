"
This class represents a layer responsible for displaying domain objects within a specific context.
The layer manages the addition, updating, and removal of domain objects, with the drawing appearance
for each object being defined within its respective class through the data processing mechanism.
The processData method within each domain object class is utilized to define the visual presentation of the object
when rendered within this layer.
"
Class {
	#name : #GeoViewDomainObjectsLayer,
	#superclass : #AbstractGeoViewGraphicModelLayer,
	#traits : 'TSmockHandleProcessDatas + TSmockHandleObjects',
	#classTraits : 'TSmockHandleProcessDatas classTrait + TSmockHandleObjects classTrait',
	#instVars : [
		'displayModel'
	],
	#category : #'GeoView-Layers'
}

{ #category : #'API -- objects management' }
GeoViewDomainObjectsLayer >> addObject: anObject [

	self addDShape: (self displayModel created: anObject)
]

{ #category : #'API -- objects management' }
GeoViewDomainObjectsLayer >> addObjects: anObjectList [

	anObjectList do: [ :e | self addObject: e ]
]

{ #category : #accessing }
GeoViewDomainObjectsLayer >> displayModel [

	^ displayModel 
]

{ #category : #accessing }
GeoViewDomainObjectsLayer >> displayModel: anObject [

	displayModel := anObject
]

{ #category : #'API -- process datas' }
GeoViewDomainObjectsLayer >> getAllProcessData [

	^ self displayModel getAllProcessData
]

{ #category : #'API -- process datas' }
GeoViewDomainObjectsLayer >> getDefaultProcessData [

	^ self displayModel getDefaultProcessData 
]

{ #category : #'API -- process datas' }
GeoViewDomainObjectsLayer >> getProcessDataForClass: aGeoObjectClass [

	^ self displayModel getProcessDataForClass: aGeoObjectClass
]

{ #category : #testing }
GeoViewDomainObjectsLayer >> haveGeoObjects [

	^ true
]

{ #category : #'API -- dshapes' }
GeoViewDomainObjectsLayer >> haveObjectIndex: anIndex [

	^ self displayModel haveDataIndex: anIndex
]

{ #category : #initialization }
GeoViewDomainObjectsLayer >> initialize [

	super initialize.
	self initializeUserToDisplayModel
]

{ #category : #initialize }
GeoViewDomainObjectsLayer >> initializeUserToDisplayModel [

	self displayModel: GeoViewModel new
]

{ #category : #'API -- projection' }
GeoViewDomainObjectsLayer >> mapProjection [

	^ self displayModel projection
]

{ #category : #'API -- projection' }
GeoViewDomainObjectsLayer >> mapProjection: aMapProjection [

	self displayModel projection: aMapProjection
]

{ #category : #private }
GeoViewDomainObjectsLayer >> populatePickingResult: aPickingResult at: index with: aGShape [
	"Way to detect if the gShape is picked"

	| pickingElement |
	pickingElement := super populatePickingResult: aPickingResult at: index with: aGShape.
	pickingElement ifNil:[ ^ nil ].
	
	"add dShape"
	pickingElement dShape: (self displayModel getData: index). 
	
 	^ pickingElement 
]

{ #category : #private }
GeoViewDomainObjectsLayer >> processDatasChanged [
	"Notify internaly that process datas changed"
	
	| announcement |
	announcement := GeoViewGeoObjectLayerProcessDataChanged new.
	announcement layerName: self name.
	self announcer announce: announcement
]

{ #category : #'API -- dshapes' }
GeoViewDomainObjectsLayer >> removeObject: anObject [

	self removeDShape: (self displayModel deleted: anObject)
]

{ #category : #'API -- dshapes' }
GeoViewDomainObjectsLayer >> removeObjects: anObjectList [

	anObjectList do: [ :e | self removeObject: e ]
]

{ #category : #'API -- process datas' }
GeoViewDomainObjectsLayer >> removeProcessDataForClass: aGeoObjectClass [

	self displayModel removeProcessDataForClass: aGeoObjectClass.
	self processDatasChanged
]

{ #category : #'API -- process datas' }
GeoViewDomainObjectsLayer >> setDefaultProcessData: aDataProcessor [

	self displayModel setDefaultProcessData: aDataProcessor.
	self processDatasChanged
]

{ #category : #'API -- process datas' }
GeoViewDomainObjectsLayer >> setProcessData: aProcessData forClass: anUserObjectClass [

	| dModel |
	dModel := self displayModel.
	dModel setProcessData: aProcessData forClass: anUserObjectClass.
	self processDatasChanged
]

{ #category : #'API -- drawing' }
GeoViewDomainObjectsLayer >> updateModel: aContext [

	| model |
	model := self displayModel.
	model datas valuesDo: [ :dShape | self updateGraphicModelWith: dShape ]
]

{ #category : #'API -- dshapes' }
GeoViewDomainObjectsLayer >> updateObject: anObject [

	self updateDShape: (self displayModel updated: anObject)
]

{ #category : #'API -- dshapes' }
GeoViewDomainObjectsLayer >> updateObjects: anObjectList [

	anObjectList do: [ :e | self updateObject: e ]
]

{ #category : #private }
GeoViewDomainObjectsLayer >> updateState: aStateSymbol withIndexes: aKeyList [

	| dModel dObjectList |
	dModel := self displayModel.
	
	"Update the state"
	dObjectList := dModel updateState: aStateSymbol withIndexes: aKeyList.
	
	"Update the graphic model to considere the updated state"
	dObjectList do:[ :dObject | self graphicModel updated: dObject ].
]

{ #category : #'API -- projection' }
GeoViewDomainObjectsLayer >> viewInfos: aViewInfos [
	
	super viewInfos: aViewInfos.
	self displayModel viewInfos: aViewInfos
]
