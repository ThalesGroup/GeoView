Class {
	#name : #GeoViewFootnotesElement,
	#superclass : #BlElement,
	#instVars : [
		'noteBackgroundColor',
		'textAttributes'
	],
	#category : #'GeoView-Core'
}

{ #category : #adding }
GeoViewFootnotesElement >> addNote: aString [

	| label |
	label := BlTextElement new.
	label text: (aString asRopedText attributes: textAttributes).
	label background: (Color black alpha: 0.6).
	label constraintsDo: [ :c | 
		c flow horizontal alignRight.
		c padding: (BlInsets all: 2.0). 
	].

	self addChild: label
]

{ #category : #adding }
GeoViewFootnotesElement >> addNotes: aStringList [

	aStringList do: [ :e | self addNote: e ]
]

{ #category : #initialization }
GeoViewFootnotesElement >> initialize [

	super initialize.
	
	self layout: (BlFlowLayout vertical alignBottomRight).
	
	textAttributes := {
		                  BlFontItalicAttribute new.
		                  (BlFontSizeAttribute new
			                   size: 12;
			                   yourself).
		                  (BlTextForegroundAttribute new
			                   paint: Color white;
			                   yourself) }
]

{ #category : #adding }
GeoViewFootnotesElement >> removeAllNotes [

	self removeChildren
]

{ #category : #initialization }
GeoViewFootnotesElement >> textAttributes [

	^ textAttributes
]

{ #category : #initialization }
GeoViewFootnotesElement >> textAttributes: aBlTextAttributeList [

	textAttributes := aBlTextAttributeList
]
