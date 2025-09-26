Class {
	#name : #AbstractGeoViewLayer,
	#superclass : #Object,
	#traits : 'TSmockHaveProperties',
	#classTraits : 'TSmockHaveProperties classTrait',
	#instVars : [
		'isVisible',
		'name',
		'announcer'
	],
	#category : #'GeoView-Layers'
}

{ #category : #testing }
AbstractGeoViewLayer class >> isAbstract [ 

	^ self == AbstractGeoViewLayer 
]

{ #category : #private }
AbstractGeoViewLayer >> addedToSceneGraph [
	"call when the geoview is added to a scene graph"

	
]

{ #category : #drawing }
AbstractGeoViewLayer >> aeDrawOn: aeCanvas [

	self subclassResponsibility 
]

{ #category : #private }
AbstractGeoViewLayer >> announce: anAnnouncement [
	"Notify an announcement"

	anAnnouncement layerName: self name.
	self announcer announce: anAnnouncement
]

{ #category : #accessing }
AbstractGeoViewLayer >> announcer [

	^ announcer ifNil:[ announcer := Announcer new ]
]

{ #category : #'API -- footnotes' }
AbstractGeoViewLayer >> footnotes [

	^ nil
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

	isVisible ~= aBoolean ifFalse: [ ^ self ].
	isVisible := aBoolean.
	self sendRepaintRequest.
	
	isVisible ifFalse: [ ^ self ].
	self updateModel: GeoViewBeVisibleChanges new
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

	self announce: GeoViewLayerRepaintRequest new
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

	"do nothing"
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewLayer >> viewInfos [
	
	self explicitRequirement
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewLayer >> viewInfos: aViewInfos [

	self explicitRequirement
]
