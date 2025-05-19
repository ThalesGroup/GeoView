Class {
	#name : #AbstractGeoViewLayer,
	#superclass : #Object,
	#instVars : [
		'isVisible',
		'name',
		'announcer',
		'commandApplicationStrategy'
	],
	#category : #'GeoView-Layers'
}

{ #category : #testing }
AbstractGeoViewLayer class >> isAbstract [ 

	^ self == AbstractGeoViewLayer 
]

{ #category : #private }
AbstractGeoViewLayer >> addCommand: aCommand [

	self commandApplicationStrategy ifNil:[ ^ self ].
	
	self flag:'on peut pas mettre autre chose quun blelement dans from:, cest dommage'.
	self commandApplicationStrategy addCommand: aCommand from: (self commandApplicationStrategy element)
]

{ #category : #private }
AbstractGeoViewLayer >> addedToSceneGraph [
	"call when the geoview is added to a scene graph"

	
]

{ #category : #drawing }
AbstractGeoViewLayer >> aeDrawOn: aeCanvas [

	self subclassResponsibility 
]

{ #category : #accessing }
AbstractGeoViewLayer >> announcer [

	^ announcer ifNil:[ announcer := Announcer new ]
]

{ #category : #accessing }
AbstractGeoViewLayer >> commandApplicationStrategy [

	^ commandApplicationStrategy
]

{ #category : #accessing }
AbstractGeoViewLayer >> commandApplicationStrategy: anObject [

	commandApplicationStrategy := anObject
]

{ #category : #'API -- projection' }
AbstractGeoViewLayer >> graphicProjection [

	self explicitRequirement
]

{ #category : #'API -- projection' }
AbstractGeoViewLayer >> graphicProjection: aGraphicProjection [

	self explicitRequirement
]

{ #category : #testing }
AbstractGeoViewLayer >> haveDomainObjects [

	^ false
]

{ #category : #testing }
AbstractGeoViewLayer >> haveGraphicModel [

	^ false
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewLayer >> isVisible [

	^ isVisible ifNil:[ isVisible := true ]
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewLayer >> isVisible: aBoolean [

	isVisible := aBoolean
]

{ #category : #'API -- projection' }
AbstractGeoViewLayer >> mapProjection [

	self explicitRequirement
]

{ #category : #'API -- projection' }
AbstractGeoViewLayer >> mapProjection: aMapProjection [

	self explicitRequirement
]

{ #category : #accessing }
AbstractGeoViewLayer >> name [

	^ name
]

{ #category : #accessing }
AbstractGeoViewLayer >> name: anObject [

	name := anObject
]

{ #category : #'API -- picking' }
AbstractGeoViewLayer >> populatePickingResult: aPickingResult [ 

	self explicitRequirement 
]

{ #category : #private }
AbstractGeoViewLayer >> removedFromSceneGraph [
	"call when the geoview is removed from a scene graph"

	
]

{ #category : #private }
AbstractGeoViewLayer >> sendRepaintRequest [
	"Notify that the layer need to be repaint, use it if the layer manage internal changes of his own graphical model"
	
	| announcement |
	announcement := GeoViewLayerRepaintRequest new.
	announcement layerName: self name.
	self announcer announce: announcement
]

{ #category : #'API -- symbology' }
AbstractGeoViewLayer >> symbologyProvider [

	self explicitRequirement
]

{ #category : #'API -- symbology' }
AbstractGeoViewLayer >> symbologyProvider: aSymbologyProvider [

	self explicitRequirement
]

{ #category : #private }
AbstractGeoViewLayer >> updateModel: aContext [

	self explicitRequirement 
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewLayer >> viewInfos [
	
	self explicitRequirement
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewLayer >> viewInfos: aViewInfos [

	self explicitRequirement
]
