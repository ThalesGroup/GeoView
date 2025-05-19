"
Test suite with a simulation of a Bloc rendering task
"
Class {
	#name : #GeoViewAeElementTest,
	#superclass : #TestCase,
	#instVars : [
		'geoView',
		'task'
	],
	#category : #'GeoView-Tests-Cases - Core'
}

{ #category : #private }
GeoViewAeElementTest >> createGeoViewElement [

	geoView := GeoViewAeElement new
]

{ #category : #private }
GeoViewAeElementTest >> createRandomPositionGeoCircles: aQuantity color: aColor radius: aRadiusInMeters [

	| list random |
	list := OrderedCollection new.
	random := Random new.

	1 to: aQuantity do: [ :i |
		| object |
		object := GeoCircle new.
		object key: i.
		object fillStyle: aColor asSmockFillStyle.
		object absoluteCoordinates: AbsoluteCoordinates random.
		object radiusInMeters: aRadiusInMeters.
		list add: object ].

	^ list
]

{ #category : #private }
GeoViewAeElementTest >> createTask: aBlockClosure delay: aDelay [

	| serv index |
	index := (Random new next * 10000) rounded.
	serv := TKTParameterizableService new
		        step: aBlockClosure;
		        name: 'GeoView test task - ', index printString;
		        stepDelay: aDelay;
		        yourself.

	^ serv
]

{ #category : #private }
GeoViewAeElementTest >> geoViewSize [

	^ 1000 @ 1000
]

{ #category : #running }
GeoViewAeElementTest >> setUp [

	| container space |
	super setUp.
	self createGeoViewElement.
	geoView constraintsDo: [ :c | c horizontal matchParent. c vertical matchParent ].
	container := BlElement new.
	container size: self geoViewSize.
	container addChild: geoView.
	
	space := BlSpace new.
	space host: BlHeadlessHost new.
	space root addChild: container.
	container forceLayout.

	"simulation a rendering thread"
	task := self createTask: [ space pulse ] delay: 16.67 milliSeconds. 
	task start.
]

{ #category : #private }
GeoViewAeElementTest >> stimulateGeoCirclesIn: aList geoView: aGeoView fromIndex: anIndex [
	"at each step create / update and delete some GeoObjects"

	| random color radiusInM createList updateList removeList newIndex maxRadiusInM maxNbOfCircles unchangeList |
	createList := OrderedCollection new.
	updateList := OrderedCollection new.
	unchangeList := OrderedCollection new.
	removeList := OrderedCollection new.
	random := Random new.
	color := Color random.
	maxRadiusInM := 300000.
	maxNbOfCircles := 10000.
	radiusInM := random next * maxRadiusInM.
	newIndex := anIndex.

	aList do: [ :circle |
		| next |
		"first randomize update / deletion"
		next := random next.
		next <= 0.1
			ifTrue: [ "update the object"
				circle fillStyle: color asSmockFillStyle.
				circle radiusInMeters: radiusInM.
				updateList add: circle ]
			ifFalse: [
				next >= 0.9
					ifTrue: [ "remove the object" removeList add: circle ]
					ifFalse: [ "do nothing ;-)" unchangeList add: circle ] ] ].

	color := Color random.
	radiusInM := random next * maxRadiusInM.

	"create objects when removed, to have between one and 1000"
	(removeList isNotEmpty and: [ aList size < maxNbOfCircles ]) ifTrue:[
		(self createRandomPositionGeoCircles: ((random next * 100) asInteger) color: color radius: radiusInM) do:[ :e |
			newIndex := newIndex + 1.
			e key: newIndex.
			createList add: e.
		].
	].

	"update geoview"
	aGeoView updateObjects: updateList.
	aGeoView removeObjects: removeList.
	aGeoView addObjects: createList.

	aList removeAll.
	aList addAll: unchangeList;	addAll: updateList; addAll: createList.
		
	^ newIndex
]

{ #category : #running }
GeoViewAeElementTest >> tearDown [

	task stop.
	geoView := nil.
	super tearDown
]

{ #category : #tests }
GeoViewAeElementTest >> testCreateUpdateRemoveObjects [
	"Create a lot of objects and stimulate them, control the state of the model"
	
	| index list updateTask layer uiTask |
	
	0.1 seconds wait.
	geoView addLayer: (GeoViewUtils createGeoObjectsLayer: #layer).
	
	index := 5000.
	list := self createRandomPositionGeoCircles: index color: Color random radius: 100000.
	geoView addObjects: list.
	
	0.1 seconds wait.
	
	"stimulate datas"
	updateTask := (self createTask: [ | newIndex |
		newIndex := self stimulateGeoCirclesIn: list geoView: geoView fromIndex: index.
		index := newIndex. 	
	] delay: 30 milliSeconds) start; yourself.

	"stimulate user interaction by updating the model"
	uiTask := (self createTask: [
		geoView updateModel: GeoViewProjectionChanges new.
	] delay: 5 milliSeconds) start; yourself.

	5 seconds wait.
	updateTask stop.
	uiTask stop.
	task stop.
	
	layer := geoView getLayer: #layer.
	"test to compare list model and graphic model"
	self assert: (layer displayModel getDatas size) equals: (list size).
	self assert: (layer graphicModel getDatas size) equals: (list size).
]
