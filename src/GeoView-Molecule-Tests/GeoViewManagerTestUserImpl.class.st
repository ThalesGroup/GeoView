Class {
	#name : #GeoViewManagerTestUserImpl,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'GeoViewManagerTestUser + GeoViewManagerCursorEvents + GeoViewManagerEvents',
	#classTraits : 'GeoViewManagerTestUser classTrait + GeoViewManagerCursorEvents classTrait + GeoViewManagerEvents classTrait',
	#instVars : [
		'center',
		'scale'
	],
	#category : #'GeoView-Molecule-Tests-Utils'
}

{ #category : #accessing }
GeoViewManagerTestUserImpl >> center [

	^ center
]

{ #category : #'life cycle' }
GeoViewManagerTestUserImpl >> componentActivate [

	super componentActivate.

	self getGeoViewManagerCursorEventsSubscriber subscribe: self.
	self getGeoViewManagerEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
GeoViewManagerTestUserImpl >> componentPassivate [

	self getGeoViewManagerCursorEventsSubscriber unsubscribe: self.
	self getGeoViewManagerEventsSubscriber unsubscribe: self.

	super componentPassivate
]

{ #category : #'events - view' }
GeoViewManagerTestUserImpl >> geoViewCenterHasChanged: anAbsoluteCoordinates in: aGeoViewManagerKey [

	center := anAbsoluteCoordinates -> aGeoViewManagerKey
]

{ #category : #'events - view' }
GeoViewManagerTestUserImpl >> geoViewScaleHasChanged: aScale in: aGeoViewManagerKey [

	scale := aScale -> aGeoViewManagerKey
]

{ #category : #'component accessing' }
GeoViewManagerTestUserImpl >> getGeoViewManagerCursorEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := GeoViewManagerCursorEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: GeoViewManagerCursorEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
GeoViewManagerTestUserImpl >> getGeoViewManagerEventsSubscriber [
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
GeoViewManagerTestUserImpl >> getGeoViewManagerObjectsServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := GeoViewManagerObjectsServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: GeoViewManagerObjectsServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
GeoViewManagerTestUserImpl >> getGeoViewManagerParametersProvider [
	| parametersSymbol parametersProvider itf |

	itf := GeoViewManagerParameters.
	parametersSymbol := self parametersProviders at: itf ifAbsent: [nil].
	(parametersSymbol isNil or:[parametersSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundParametersProvider new interface: itf name: nil ].

	parametersProvider := MolComponentManager default locatorServices searchParametersProviderFor: GeoViewManagerParameters named: parametersSymbol.
	^parametersProvider
]

{ #category : #'component accessing' }
GeoViewManagerTestUserImpl >> getGeoViewManagerPickingServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := GeoViewManagerPickingServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: GeoViewManagerPickingServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
GeoViewManagerTestUserImpl >> getGeoViewManagerServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := GeoViewManagerServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: GeoViewManagerServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #accessing }
GeoViewManagerTestUserImpl >> scale [

	^ scale
]
