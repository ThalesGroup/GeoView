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

	self addChild: label
]

{ #category : #adding }
GeoViewFootnotesElement >> addNotes: aStringList [

	aStringList do: [ :e | self addNote: e ]
]

{ #category : #initialization }
GeoViewFootnotesElement >> initialize [

	super initialize.
	textAttributes := {
		                  BlFontItalicAttribute new.
		                  (BlFontSizeAttribute new
			                   size: 12;
			                   yourself).
		                  (BlTextBackgroundAttribute new
			                   paint: (Color black alpha: 0.6);
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
