Class {
	#name : #GeoViewExamplesBlocMolecule,
	#superclass : #Object,
	#category : #'GeoView-Examples-Bloc-Molecule'
}

{ #category : #private }
GeoViewExamplesBlocMolecule class >> createGeoObjects [

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
GeoViewExamplesBlocMolecule class >> exampleWithGeoObjects [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent a static (no updates) geographical view with a lot of data."
	
	| geoViewManager layer objects |
	geoViewManager := GeoViewManagerBlocAeImpl start: #GeoViewManager , Random new next printString. 

	layer := GeoViewUtils createGeoObjectsLayer: #layer1.
	layer := geoViewManager addLayer: layer.
	
	"create sample datas"
	objects := self createGeoObjects.
	geoViewManager addObjects: objects.
	
	^ self openViewInWindow: geoViewManager
]

{ #category : #examples }
GeoViewExamplesBlocMolecule class >> exampleWithGeoObjectsUpdated [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent updated geographical view with a lot of data."
	
	| geoViewManager layer objects space thread |
	geoViewManager := GeoViewManagerBlocAeImpl start: #GeoViewManager , Random new next printString. 

	layer := GeoViewUtils createGeoObjectsLayer: #layer1.
	layer := geoViewManager addLayer: layer.
	
	"create sample datas"
	objects := self createGeoObjects.
	geoViewManager addObjects: objects.
	
	space := self openViewInWindow: geoViewManager.
	
	"Objet update thread"
	thread := [ | random |
		random := Random new.
		[ true ] whileTrue:[
			1 second wait.
			objects do:[ :o |
				o radiusInMeters: (random next * 200000).	
				geoViewManager updateObject: o.
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
GeoViewExamplesBlocMolecule class >> openViewInWindow: aGeoViewManager [
	"open the view in a window"

	| blElement space |
	blElement := aGeoViewManager getView.
	blElement constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	space := blElement openInSpace.
	space title: 'GeoView Molecule example'.

	space addEventHandler: (BlEventHandler
			 on: BlSpaceCloseRequest
			 do: [ :event |
			 aGeoViewManager class stop: aGeoViewManager componentName ]).

	^ space
]

{ #category : #'see class side' }
GeoViewExamplesBlocMolecule >> seeClassSide [ 
]
