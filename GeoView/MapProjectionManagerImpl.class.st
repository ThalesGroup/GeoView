"
I am the default ProjectionManager implementation.
"
Class {
	#name : #MapProjectionManagerImpl,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'MapProjectionManager + MapProjectionManagerServices + MapProjectionManagerParameters',
	#classTraits : 'MapProjectionManager classTrait + MapProjectionManagerServices classTrait + MapProjectionManagerParameters classTrait',
	#instVars : [
		'projection'
	],
	#category : #'GeoView-MapProjection'
}

{ #category : #'life cycle' }
MapProjectionManagerImpl >> componentActivate [

	
]

{ #category : #'life cycle' }
MapProjectionManagerImpl >> componentInitialize [
	self createProjection
]

{ #category : #'life cycle' }
MapProjectionManagerImpl >> componentPassivate [

	
]

{ #category : #'life cycle' }
MapProjectionManagerImpl >> componentRemove [
	
]

{ #category : #'initalize-release' }
MapProjectionManagerImpl >> createProjection [
	"default projection is Mercator"

	self projection: MercatorProjection new
]

{ #category : #'component accessing' }
MapProjectionManagerImpl >> getMapProjectionManagerEventsNotifier [
	^self eventsNotifiers at: MapProjectionManagerEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: MapProjectionManagerEvents name: nil].
]

{ #category : #projection }
MapProjectionManagerImpl >> getProjection [
	^self projection copy
]

{ #category : #accessing }
MapProjectionManagerImpl >> projection [
	^ projection
]

{ #category : #accessing }
MapProjectionManagerImpl >> projection: anObject [
	projection := anObject
]

{ #category : #projection }
MapProjectionManagerImpl >> setProjection: aProjection [
	self assert: [ aProjection isNotNil ] description: [ '[Geoplot] Projection can not be nil.' ].
	self projection ~= aProjection
		ifTrue: [ self projection: aProjection copy.
			"self view projection: aProjection."
			self getMapProjectionManagerEventsNotifier projectionHasChanged: aProjection ]
]

{ #category : #projection }
MapProjectionManagerImpl >> updateProjection: aProjection [
	self
		assert: [ aProjection isNotNil ]
		description: [ '[Geoplot] Projection can not be nil.' ].
		
	"if the projection is the same we can update parameters of the projection"
	self projection key = aProjection key ifTrue:[
		self projection:  aProjection copy.
		self getMapProjectionManagerEventsNotifier projectionUpdated: aProjection
	].
]
