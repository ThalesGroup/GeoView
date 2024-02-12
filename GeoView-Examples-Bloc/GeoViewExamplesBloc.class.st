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
	nb := 500.
	
	1 to: nb do:[ :i | | object |
		object := GeoCircle new.
		object key: i.
		object absoluteCoordinates: AbsoluteCoordinates random.
		object radiusInMeters: (random next * 100000).
		list add: object.
	].

	^ list
]

{ #category : #examples }
GeoViewExamplesBloc class >> exampleWithGeoObjects [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent a static (no updates) geographical view with a lot of data."
	
	| geoViewManager layer objects |
	geoViewManager := GeoViewManagerBlocAeImpl start: #GeoViewManager , Random new next printString. 
	
	"parameters"
	geoViewManager setObjectIndexAccessor: #key.
	
	"configure projection"
	geoViewManager getMapProjectionManagerServicesProvider setProjection: MercatorProjection new.
	
	"configure layers and process datas : objects that can be displayed and how"
	layer := geoViewManager createAndAddLayer: #layer1.
	layer setProcessData: GeoCircleProcessData for: GeoCircle.
	layer setProcessData: GeoEllipseProcessData new for: GeoEllipse.
	layer setProcessData: GeoPolygonProcessData new for: GeoPolygon.
	layer setProcessData: GeoPolylineProcessData new for: GeoPolyline.
	layer setProcessData: GeoRectangleProcessData new for: GeoRectangle.
	layer setProcessData: GeoTextProcessData new for: GeoText.
	layer setProcessData: GeoArcBandProcessData new for: GeoArcBand.
	
	"create sample datas"
	objects := self createGeoObjects.
	geoViewManager addObjects: objects.
	
	self openViewInWindow: geoViewManager.
]

{ #category : #private }
GeoViewExamplesBloc class >> openViewInWindow: aGeoViewManager [

	"open the view in a window"
	| blElement space |
	blElement := aGeoViewManager getView.
	blElement constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	space := blElement openInSpace.
	space title: 'GeoView example'.
	
	space addEventHandler: (BlEventHandler
			 on: BlSpaceCloseRequest
			 do: [ :event |
			 aGeoViewManager class stop: aGeoViewManager componentName ])
]

{ #category : #'see class side' }
GeoViewExamplesBloc >> seeClassSide [ 
]
