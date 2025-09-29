"
I am a BlElement which display a GeoViewWidget using Alexandrie backend drawing.
"
Class {
	#name : #GeoViewElement,
	#superclass : #GeoViewAbstractElement,
	#instVars : [
		'layerListElement',
		'interactionsStrategy',
		'footnotes',
		'footnotesElement'
	],
	#category : #'GeoView-Core'
}

{ #category : #'API -- footnotes' }
GeoViewElement >> footnotes [

	^ footnotes
]

{ #category : #'API -- footnotes' }
GeoViewElement >> footnotes: aStringOrNil [

	footnotes := aStringOrNil
]

{ #category : #accessing }
GeoViewElement >> footnotesElement [

	^ footnotesElement
]

{ #category : #accessing }
GeoViewElement >> footnotesElement: aFootnoteElement [

	footnotesElement ifNotNil: [ self removeChild: footnotesElement ].

	footnotesElement := aFootnoteElement.

	footnotesElement ifNotNil: [
			self addChild: footnotesElement.
			self updateFootnotes ]
]

{ #category : #initialization }
GeoViewElement >> initialize [

	super initialize.

	self initializeLayerListElement.
	self initializeFootnotesElements.

	"Default background"
	self background: Color black.

	"Initialize events behavior"
	self initializeInteractionsStrategy.
	self initializeEventHandlers
]

{ #category : #initialization }
GeoViewElement >> initializeEventHandlers [
	"Add listener to compute things when extents changed"

	self addEventHandler: (BlEventHandler
			 on: BlElementExtentChangedEvent
			 do: [ :e | self processExtentChangedEvent: e ])
]

{ #category : #initialization }
GeoViewElement >> initializeFootnotesElements [
	"Create the element do display footnotes"

	| element |
	element := GeoViewFootnotesElement id: #footnotes.
	
	element constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent.
		c padding: (BlInsets all: 4.0).
	].
	
	self footnotesElement: element 
]

{ #category : #initialization }
GeoViewElement >> initializeInteractionsStrategy [
	"Add behavior to process Bloc UI events interactions"

	self setInteractionsStrategy: self newInteractionsStrategy
]

{ #category : #initialization }
GeoViewElement >> initializeLayerListElement [
	"Create the element which render layers"

	layerListElement := GeoViewLayerListElement new id: #layers.
	
	layerListElement constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].

	layerListElement layers: self layers.

	self addChildFirst: layerListElement
]

{ #category : #'strategy management' }
GeoViewElement >> interactionsStrategy [

	^ interactionsStrategy
]

{ #category : #accessing }
GeoViewElement >> layerListElement [

	^ layerListElement 
]

{ #category : #'strategy management' }
GeoViewElement >> newInteractionsStrategy [

	^ GeoViewInteractionsStrategy new
]

{ #category : #'strategy management' }
GeoViewElement >> removeInteractionsStrategy [

	interactionsStrategy ifNil:[ ^ self ].
	self removeEventHandler: interactionsStrategy.
	interactionsStrategy := nil.
]

{ #category : #'strategy management' }
GeoViewElement >> setInteractionsStrategy: aBlEventListener [

	self removeInteractionsStrategy.

	aBlEventListener ifNil:[ ^ self ].
	interactionsStrategy := aBlEventListener.
	self addEventHandler: aBlEventListener.
]

{ #category : #private }
GeoViewElement >> updateFootnotes [
	"Collect footnotes from layers and myself"

	| notes |
	self footnotesElement ifNil: [ ^ self ].

	notes := OrderedCollection new.
	notes addAll: (self layers
			 collect: [ :l | l footnotes ]
			 thenSelect: [ :e | e notNil and: [ e notEmpty ] ]).

	(self footnotes notNil and: [ self footnotes notEmpty ]) ifTrue: [
		notes add: self footnotes ].

	self footnotesElement removeAllNotes.
	self footnotesElement addNotes: notes
]

{ #category : #private }
GeoViewElement >> updateModel: aContext [

	super updateModel: aContext.

	self updateFootnotes
]
