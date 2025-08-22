"
Example to illustrate how extend an existing DShape layer to write specific decoration.
Note : can be make without extend classes.
"
Class {
	#name : #GeoViewDShapesExampleRectangleLayer,
	#superclass : #GeoViewDShapesLayer,
	#instVars : [
		'rectangle1',
		'rectangle2'
	],
	#category : #'GeoView-Examples'
}

{ #category : #initialization }
GeoViewDShapesExampleRectangleLayer >> initialize [

	super initialize.

	rectangle1 := (SmockDRectangle key: #rectangle1)
		              setDrawModeDevice;
		              coordinates: 10 @ 10;
		              length1: 100;
		              length2: 100;
		              strokeColor: Color yellow;
		              strokeWidth: 4.

	rectangle2 := (SmockDRectangle key: #rectangle2)
		              setDrawModeDevice;
		              coordinates: 20 @ 20;
		              length1: 100;
		              length2: 100;
		              strokeColor: Color yellow;
		              strokeWidth: 4.

	self addDShapes: {
			rectangle1.
			rectangle2 }
]

{ #category : #private }
GeoViewDShapesExampleRectangleLayer >> updateModel: aContext [

	| extent |
	extent := self viewInfos extent.

	rectangle1
		length1: extent x - 20;
		length2: extent y - 20.
	rectangle2
		length1: extent x - 40;
		length2: extent y - 40.

	self updateDShapes: {
			rectangle1.
			rectangle2 }.

	super updateModel: aContext.
]
