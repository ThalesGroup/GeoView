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

	| shapes |
	self userDataChangesMutex critical: [
		shapes := self displayModel created: anObject .
	self addDShape: shapes ]
]

{ #category : #'API -- objects management' }
GeoViewDomainObjectsLayer >> addObjects: anObjectList [

	| dShapeList |
	anObjectList ifNil: [ ^ self ].

	dShapeList := OrderedCollection new.
	self userDataChangesMutex critical: [
		anObjectList do: [ :e |
			(self displayModel created: e) ifNotNil: [ :f | dShapeList add: f ] ] .

	self addDShapes: dShapeList ]
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
GeoViewDomainObjectsLayer >> getProcessDataForClass: aDomainObjectClass [

	^ self displayModel getProcessDataForClass: aDomainObjectClass
]

{ #category : #testing }
GeoViewDomainObjectsLayer >> haveDomainObjects [

	^ true
]

{ #category : #'API -- objects management' }
GeoViewDomainObjectsLayer >> haveObjectIndex: anIndex [

	| index |
	self userDataChangesMutex critical: [
		index := self displayModel haveDataIndex: anIndex ].
	^ index
]

{ #category : #initialization }
GeoViewDomainObjectsLayer >> initialize [

	super initialize.
	self initializeDisplayModel
]

{ #category : #initialization }
GeoViewDomainObjectsLayer >> initializeDisplayModel [

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

	| pickingElement data |
	pickingElement := super populatePickingResult: aPickingResult at: index with: aGShape.
	pickingElement ifNil:[ ^ nil ].
	
	"add dShape"
	self userDataChangesMutex critical: [ data := self displayModel getData: index ].
	pickingElement dShape: data. 
	
 	^ pickingElement 
]

{ #category : #private }
GeoViewDomainObjectsLayer >> processDatasChanged [
	"Notify internaly that process datas changed"
	
	| announcement |
	announcement := GeoViewDomainObjectsLayerProcessDataChanged new.
	announcement layerName: self name.
	self announcer announce: announcement
]

{ #category : #'API -- objects management' }
GeoViewDomainObjectsLayer >> removeObject: anObject [

	| shape |
	self userDataChangesMutex critical: [
		shape := self displayModel deleted: anObject .

	self removeDShape: shape ]
]

{ #category : #'API -- objects management' }
GeoViewDomainObjectsLayer >> removeObjects: anObjectList [

	| dShapeList |
	anObjectList ifNil: [ ^ self ].

	dShapeList := OrderedCollection new.
	self userDataChangesMutex critical: [
		anObjectList do: [ :e |
			(self displayModel deleted: e) ifNotNil: [ :f | dShapeList add: f ] ] .

	self removeDShapes: dShapeList ]
]

{ #category : #'API -- process datas' }
GeoViewDomainObjectsLayer >> removeProcessDataForClass: aDomainObjectClass [

	self displayModel removeProcessDataForClass: aDomainObjectClass.
	self processDatasChanged
]

{ #category : #'API -- process datas' }
GeoViewDomainObjectsLayer >> setDefaultProcessData: aDataProcessor [

	self displayModel setDefaultProcessData: aDataProcessor.
	self processDatasChanged
]

{ #category : #'API -- process datas' }
GeoViewDomainObjectsLayer >> setProcessData: aProcessData forClass: aDomainObjectClass [

	| dModel |
	dModel := self displayModel.
	dModel setProcessData: aProcessData forClass: aDomainObjectClass.
	self processDatasChanged
]

{ #category : #private }
GeoViewDomainObjectsLayer >> updateModel: aContext [

	| shapes |
	self userDataChangesMutex critical: [
		shapes := self displayModel getDatas.

	self updateDShapes: shapes ]
]

{ #category : #'API -- objects management' }
GeoViewDomainObjectsLayer >> updateObject: anObject [

	| shape |
	self userDataChangesMutex critical: [
		shape := self displayModel updated: anObject.

	self updateDShape: shape ]
]

{ #category : #'API -- objects management' }
GeoViewDomainObjectsLayer >> updateObjects: anObjectList [

	| dShapeList |
	dShapeList := OrderedCollection new.
	self userDataChangesMutex critical: [
		anObjectList do: [ :e |
			(self displayModel updated: e) ifNotNil: [ :f | dShapeList add: f ] ] .

	self updateDShapes: dShapeList ]
]

{ #category : #'private - state' }
GeoViewDomainObjectsLayer >> updateState: aStateSymbol withIndexes: aKeyList [

	| shapes |
	"Update the state"
	self userDataChangesMutex critical: [
		shapes := self displayModel
			          updateState: aStateSymbol
			          withIndexes: aKeyList .

	"Update the graphic model to considere the updated state"
	self updateDShapes: shapes ]
]

{ #category : #'API -- graphic properties' }
GeoViewDomainObjectsLayer >> viewInfos: aViewInfos [
	
	super viewInfos: aViewInfos.
	self displayModel viewInfos: aViewInfos
]
