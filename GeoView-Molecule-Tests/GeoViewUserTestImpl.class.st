Class {
	#name : #GeoViewUserTestImpl,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'GeoViewUserTest + GeoViewManagerEvents + GeoViewManagerLayerEvents',
	#classTraits : 'GeoViewUserTest classTrait + GeoViewManagerEvents classTrait + GeoViewManagerLayerEvents classTrait',
	#instVars : [
		'receivedGeoViewLayerEvents'
	],
	#category : #'GeoView-Molecule-Tests-Utils'
}

{ #category : #events }
GeoViewUserTestImpl >> geoViewLayerAdded: aKey in: aGeoViewManagerKey [
	self receivedGeoViewLayerEvents at: #layerAddedEvent put: (aKey -> aGeoViewManagerKey).
]

{ #category : #events }
GeoViewUserTestImpl >> geoViewLayerRemoved: aKey in: aGeoViewManagerKey [
	self receivedGeoViewLayerEvents at: #layerDeletedEvent put: (aKey -> aGeoViewManagerKey).
]

{ #category : #events }
GeoViewUserTestImpl >> geoViewLayerUpdated: aKey in: aGeoViewManagerKey [
	self receivedGeoViewLayerEvents at: #layerUpdatedEvent put: (aKey -> aGeoViewManagerKey).
]

{ #category : #'component accessing' }
GeoViewUserTestImpl >> getGeoViewManagerEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := GeoViewManagerEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: GeoViewManagerEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
GeoViewUserTestImpl >> getGeoViewManagerLayerEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := GeoViewManagerLayerEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: GeoViewManagerLayerEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #callbacks }
GeoViewUserTestImpl >> receivedGeoViewLayerEvents [
	receivedGeoViewLayerEvents ifNil:[receivedGeoViewLayerEvents := Dictionary new].
	^receivedGeoViewLayerEvents 
]
