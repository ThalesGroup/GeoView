"
I am an abstract BlElement which contains GeoViewWidget behavior. Not possible to use directly, to use a GeoViewWidget select a subclass element with the targeted backend.
"
Class {
	#name : #BlAbstractGeoViewElement,
	#superclass : #BlElement,
	#traits : 'TGeoViewWidget',
	#classTraits : 'TGeoViewWidget classTrait',
	#instVars : [
		'layers',
		'displayToGraphicProjection',
		'isMarkedForSortDatas'
	],
	#category : #'GeoView-Bloc-Core'
}

{ #category : #accessing }
BlAbstractGeoViewElement >> displayToGraphicProjection [

	^ displayToGraphicProjection
]

{ #category : #accessing }
BlAbstractGeoViewElement >> displayToGraphicProjection: anObject [

	| extent |
	displayToGraphicProjection := anObject.
	displayToGraphicProjection ifNil: [ ^ self ].
	
	extent := self getBounds extent.
	displayToGraphicProjection offsetInPixels: extent / 2.
	displayToGraphicProjection updateResolution: extent.
	self updateGraphicModel
]

{ #category : #private }
BlAbstractGeoViewElement >> enqueueBlockAsTask: aBlockClosure [

	| task |
	task := BlTaskAction new.
	task action: aBlockClosure.
	self enqueueTask: task
]

{ #category : #accessing }
BlAbstractGeoViewElement >> initialize [

	super initialize.

	self background: Color black.
	self displayToGraphicProjection: GeoView2DProjection new.
]

{ #category : #accessing }
BlAbstractGeoViewElement >> layers [

	^ layers ifNil: [ layers := OrderedCollection new ]
]

{ #category : #private }
BlAbstractGeoViewElement >> requestRepaint [

	self invalidate.
]

{ #category : #'API -- drawing' }
BlAbstractGeoViewElement >> updateGraphicModel [
	"Update the graphic model with the Display model"

	self enqueueBlockAsTask: [
		self layers do: [ :e | e updateGraphicModel ].
		self requestRepaint ]
]
