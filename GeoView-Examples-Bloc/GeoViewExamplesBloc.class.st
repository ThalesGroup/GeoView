Class {
	#name : #GeoViewExamplesBloc,
	#superclass : #Object,
	#category : #'GeoView-Examples-Bloc'
}

{ #category : #private }
GeoViewExamplesBloc class >> createGeoObjects [

	| list random nb |
	list := OrderedCollection new.
	random := Random new.
	nb := 1000.
	
	1 to: nb do:[ :i | | object |
		object := GeoCircle new.
		object key: i.
		object fillStyle: (Color random asSmockFillStyle).
		object strokeStyle: (Color random asSmockStrokeStyle).
		object absoluteCoordinates: AbsoluteCoordinates random.
		object radiusInMeters: (random next * 100000).
		list add: object.
	].

	^ list
]

{ #category : #examples }
GeoViewExamplesBloc class >> exampleWithGeoCircle [
	
	| element circle |
	element := BlGeoViewAeElement new.
	
	"configure layers and process datas : objects that can be displayed and how"
	element addLayer: (GeoViewUtils createGeoObjectsLayer: #layer1).
	
	"create sample datas"
	circle := GeoCircle new key: 1; radiusInMeters: 1000000; strokeStyle: (Color white asSmockStrokeStyle); absoluteCoordinates: AbsoluteCoordinates zero.
	element addObject: circle.

	^ self openViewInWindow: element
]

{ #category : #examples }
GeoViewExamplesBloc class >> exampleWithGeoLabeledCircle [
	
	| element circle layer |
	element := BlGeoViewAeElement new.
	
	"configure layers and process datas : objects that can be displayed and how"
	layer := GeoViewUtils createGeoObjectsLayer: #layer1.
	layer setProcessData: GeoLabeledCircleProcessData new forClass: GeoCircle. 
	element addLayer: layer.
	
	"create sample datas"
	circle := GeoCircle new key: 1; radiusInMeters: 1000000; strokeStyle: (Color white asSmockStrokeStyle); absoluteCoordinates: AbsoluteCoordinates zero.
	element addObject: circle.

	^ self openViewInWindow: element
]

{ #category : #examples }
GeoViewExamplesBloc class >> exampleWithGeoObjects [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent a static (no updates) geographical view with a lot of data."
	
	| element layer objects |
	element := BlGeoViewAeElement new.
	
	"configure layers and process datas : objects that can be displayed and how"
	layer := GeoViewUtils createGeoObjectsLayer: #layer1.
	element addLayer: layer.
	
	"create sample datas"
	objects := self createGeoObjects.
	element addObjects: objects.

	"Example of event handler behavior on geoView domain event"
	element addEventHandlerOn: GeoViewCursorCoordinatesChangedEvent do: [ :event |
		event absoluteCoordinates printString traceCr.
	].

	"Example of custom EventHandler, here a logger"
	element addEventHandler: (GeoViewEventLogger new).

	^ self openViewInWindow: element
]

{ #category : #examples }
GeoViewExamplesBloc class >> exampleWithGeoObjectsUpdated [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent updated geographical view with a lot of data."
	
	| element layer objects space thread |
	element := BlGeoViewAeElement new. 

	"configure layers and process datas : objects that can be displayed and how"
	layer := GeoViewUtils createGeoObjectsLayer: #layer1.
	element addLayer: layer.
	
	"create sample datas"
	objects := self createGeoObjects.
	element addObjects: objects.
	
	space := self openViewInWindow: element.
	
	"Objet update thread"
	thread := [ | random |
		random := Random new.
		[ true ] whileTrue:[
			1 second wait.
			objects do:[ :o |
				o radiusInMeters: (random next * 200000).	
				element updateObject: o.
			].
		].
	] forkAt: Processor userBackgroundPriority named: 'GeoView objects update example'.
	
	"Stop thread when window is closed"
	space addEventHandler: (BlEventHandler
			 on: BlSpaceCloseRequest
			 do: [ :event | thread terminate. ]).

	^ space
]

{ #category : #private }
GeoViewExamplesBloc class >> openViewInWindow: aBlGeoViewElement [
	"open the view in a window"

	| space |
	aBlGeoViewElement constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	space := aBlGeoViewElement openInSpace.
	space title: 'GeoView example'.

	^ space
]

{ #category : #'see class side' }
GeoViewExamplesBloc >> seeClassSide [ 
]
