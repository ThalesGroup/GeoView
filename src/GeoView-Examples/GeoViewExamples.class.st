Class {
	#name : #GeoViewExamples,
	#superclass : #Object,
	#category : #'GeoView-Examples'
}

{ #category : #private }
GeoViewExamples class >> createAndStartTask: aBlockClosure [

	^ (self createTask: aBlockClosure)
		  start;
		  yourself
]

{ #category : #private }
GeoViewExamples class >> createGeoObjects [

	^ self createGeoObjects: 1000
]

{ #category : #private }
GeoViewExamples class >> createGeoObjects: aQuantity [

	| list random nb |
	list := OrderedCollection new.
	random := Random new.
	nb := aQuantity.
	
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

{ #category : #private }
GeoViewExamples class >> createRandomPositionGeoCircles: aQuantity color: aColor radius: aRadiusInMeters [

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
GeoViewExamples class >> createTask: aBlockClosure [

	| serv index |
	index := (Random new next * 10000) rounded.
	serv := TKTParameterizableService new
		        step: aBlockClosure;
		        name: 'GeoView examples task - ', index printString;
		        stepDelay: 1 second;
		        yourself.

	^ serv
]

{ #category : #examples }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayer [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent a static (no updates) geographical view with a lot of data."
	
	| element layer |
	element := GeoViewAeElement new.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer new.
	layer name: 'SampleCartoLayer'.
	element addLayer: layer.

	^ self openViewInWindow: element
	
]

{ #category : #examples }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerWithUpdateCenter [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent a static (no updates) geographical view with a lot of data."
	
	| element layer newCenter space circle|
	element := GeoViewUtils createGeoViewForGeoObjects.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	element scaleInMeters: 150000.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer new.
	layer name: 'SampleCartoLayer'.
	layer allowSlideMoving: false.
	element addLayerAtFirst: layer.
	
	circle := GeoCircle new key: 1; radiusInMeters: 2000; fillStyle: (Color red asSmockStrokeStyle); absoluteCoordinates: AbsoluteCoordinates frBrest.
	element addObject: circle.

	space := self openViewInWindow: element.
	space setExtent: 1200@800.
	1 seconds wait.
	newCenter := AbsoluteCoordinates frBrest copy.
	[ (1 to: 30) do:[:i | 1 seconds wait.
		newCenter := AbsoluteCoordinates latitudeInDegrees: (newCenter latitudeInDegrees + 0.05)  longitudeInDegrees: (newCenter longitudeInDegrees + 0.05).
		element geoCenter: newCenter.
		circle absoluteCoordinates:newCenter.
		element updateObjects: (OrderedCollection with: circle).
		]
	] forkAt: Processor userBackgroundPriority 
	
]

{ #category : #examples }
GeoViewExamples class >> exampleWithDShapesLayer [
	
	| element layer circle1 circle2 segment1 segment2 |
	element := GeoViewAeElement new.
	layer := GeoViewDShapesLayer new name: #shapes. 
	element addLayer: layer.
	
	"User circle (not projected)"
	circle1 := (SmockDCircle key: #circle1) coordinates: (element mapProjection projLatLonToCart: AbsoluteCoordinates zero); radius: 1000000; strokeColor: Color green; strokeWidth: 2.
	layer addDShape: circle1.

	"Device circle"
	circle2 := (SmockDCircle key: #circle2) coordinates: 100@100; radius: 100; strokeColor: Color yellow; strokeWidth: 2; setDrawModeDevice.
	layer addDShape: circle2.

	"User segment"
	segment1 := (SmockDSegment key: #segment1) coordinates: (element mapProjection projLatLonToCart: AbsoluteCoordinates frParis); coordinates2: (element mapProjection projLatLonToCart: AbsoluteCoordinates frBrest); strokeColor: Color green; strokeWidth: 2.
	layer addDShape: segment1.
	
	"Device segment"
	segment2 := (SmockDSegment key: #segment2) coordinates: 150@150; coordinates2: 250@250; strokeColor: Color yellow; strokeWidth: 2; setDrawModeDevice.
	layer addDShape: segment2.

	^ self openViewInWindow: element
]

{ #category : #examples }
GeoViewExamples class >> exampleWithGeoCircle [
	
	| element circle |
	element := GeoViewUtils createGeoViewForGeoObjects.
	
	"create sample datas"
	circle := GeoCircle new key: 1; radiusInMeters: 1000000; strokeStyle: (Color white asSmockStrokeStyle); absoluteCoordinates: AbsoluteCoordinates zero.
	element addObject: circle.

	^ self openViewInWindow: element
]

{ #category : #examples }
GeoViewExamples class >> exampleWithGeoLabeledCircle [
	
	| element circle |
	element := GeoViewUtils createGeoViewForGeoObjects.
	
	"change the default processData of the GeoObject layer to render GeoCircle by a different way"
	(element getLayer: #GeoObjectsLayer) setProcessData: GeoLabeledCircleProcessData new forClass: GeoCircle. 
	
	"create sample datas"
	circle := GeoCircle new key: 1; radiusInMeters: 1000000; strokeStyle: (Color white asSmockStrokeStyle); absoluteCoordinates: AbsoluteCoordinates zero.
	element addObject: circle.

	^ self openViewInWindow: element
]

{ #category : #examples }
GeoViewExamples class >> exampleWithGeoObjects [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent a static (no updates) geographical view with a lot of data."
	
	| element objects |
	element := GeoViewUtils createGeoViewForGeoObjects.
	
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
GeoViewExamples class >> exampleWithGeoObjectsAlt [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent a static (no updates) geographical view with a lot of data."
	
	| element objects |
	element := GeoViewUtils createGeoViewForGeoObjects.
	
	"create sample datas one by one (not optimal but usefull for testing performances)"
	objects := self createGeoObjects.
	objects do: [ :e | element addObject: e ].

	"Example of event handler behavior on geoView domain event"
	element addEventHandlerOn: GeoViewCursorCoordinatesChangedEvent do: [ :event |
		event absoluteCoordinates printString traceCr.
	].

	"Example of custom EventHandler, here a logger"
	element addEventHandler: (GeoViewEventLogger new).

	^ self openViewInWindow: element
]

{ #category : #examples }
GeoViewExamples class >> exampleWithGeoObjectsStimulation [
	"This example use ready-to-use geo-object classes (GeoObject and processData) with creation, update and deletion"

	| element space task list index |
	element := GeoViewUtils createGeoViewForGeoObjects.
	space := self openViewInWindow: element.

	"initial object list"
	index := 5000.
	list := self createRandomPositionGeoCircles: index color: Color random radius: 100000.
	element addObjects: list.

	"Objet update thread"
	task := self createAndStartTask: [ | newIndex |
		newIndex := self stimulateGeoCirclesIn: list geoView: element fromIndex: index.
		index := newIndex. 
	].
	task stepDelay: 30 milliSecond.

	"Stop thread when window is closed"
	space addEventHandler: (BlEventHandler
			 on: BlSpaceCloseRequest
			 do: [ :event | task kill ]).

	^ space
]

{ #category : #examples }
GeoViewExamples class >> exampleWithGeoObjectsUpdated [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent updated geographical view with a lot of data."

	| element objects space task |
	element := GeoViewUtils createGeoViewForGeoObjects.

	"create sample datas"
	objects := self createGeoObjects.
	element addObjects: objects.
	space := self openViewInWindow: element.

	"Objet update thread"
	task := self createAndStartTask: [
		        | random |
		        random := Random new.
		        objects do: [ :o |
			        o radiusInMeters: random next * 200000.
			        element updateObject: o ] ].

	"Stop thread when window is closed"
	space addEventHandler: (BlEventHandler
			 on: BlSpaceCloseRequest
			 do: [ :event | task kill ]).

	^ space
]

{ #category : #examples }
GeoViewExamples class >> exampleWithGeoPositions [
	
	| geoView city |
	geoView := GeoViewUtils createGeoViewForGeoObjects.
	geoView id: #geoView.
	
	city := GeoPosition new key: 1.
	city text: 'Brest'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frBrest).
	geoView addObject: city.
	
	city := GeoPosition new key: 2.
	city text: 'Nevers'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frNevers).
	geoView addObject: city.

	city := GeoPosition new key: 3.
	city text: 'Bordeaux'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frBordeaux).
	geoView addObject: city.
	
	city := GeoPosition new key: 4.
	city text: 'Marseille'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frMarseille).
	geoView addObject: city.
	
	city := GeoPosition new key: 5.
	city text: 'Lyon'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frLyon).
	geoView addObject: city.
	
	city := GeoPosition new key: 6.
	city text: 'Saint Renan'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frStRenan).
	geoView addObject: city.
	
	city := GeoPosition new key: 7.
	city text: 'Paris'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frParis).
	geoView addObject: city.
	
	city := GeoPosition new key: 8.
	city text: 'Elancourt'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frElancourt).
	geoView addObject: city.
	
	^ self openViewInWindow: geoView
]

{ #category : #private }
GeoViewExamples class >> openViewInWindow: aGeoViewElement [
	"open the view in a window"

	| space |
	aGeoViewElement constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	space := aGeoViewElement openInSpace.
	space title: 'GeoView example'.

	^ space
]

{ #category : #private }
GeoViewExamples class >> stimulateGeoCirclesIn: aList geoView: aGeoView fromIndex: anIndex [
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

{ #category : #'see class side' }
GeoViewExamples >> seeClassSide [ 
]
