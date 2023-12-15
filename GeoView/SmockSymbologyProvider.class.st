"
This require as input :
- a key from this Symbology 
- a dictionary key / filepath for symbol definition 
"
Class {
	#name : #SmockSymbologyProvider,
	#superclass : #Object,
	#traits : 'MolComponentImpl + SmockSymbologyManager + SmockSymbologyManagerServices',
	#classTraits : 'MolComponentImpl classTrait + SmockSymbologyManager classTrait + SmockSymbologyManagerServices classTrait',
	#instVars : [
		'currentSymbology'
	],
	#classVars : [
		'symbologyTable'
	],
	#category : #'GeoView-Symbology'
}

{ #category : #adding }
SmockSymbologyProvider class >> addSymbology: aKey imageDictionary: aDictionary [

	self symbologyTable at: aKey put: (aDictionary copy).


]

{ #category : #adding }
SmockSymbologyProvider class >> addSymbology: aKey key: aSymbolKey image: aSymbolForm [

"This require as input :
- a key for this Symbology 
- a key for the Symbol
- a Form for symbol definition"

"Create dictionary for key / symbol for this new Symbology is needed"
self symbologyTable at: aKey ifAbsentPut: [ Dictionary new].

"Add the new Symbol"
(self symbologyTable at:aKey) at:aSymbolKey put:aSymbolForm.

]

{ #category : #adding }
SmockSymbologyProvider class >> addSymbology: aKey key: aSymbolKey imageFilePath: aSymbolFilePath [

"This require as input :
- a key for this Symbology 
- a key for the Symbol
- a Form for symbol definition"

"Create dictionary for key / symbol for this new Symbology is needed"
| image |
self symbologyTable at: aKey ifAbsentPut: [ Dictionary new].

image := (ImageReadWriter formFromStream: ( aSymbolFilePath asFileReference binaryReadStream )).
"Add the new Symbol"
(self symbologyTable at:aKey) at:aSymbolKey put:image.

]

{ #category : #adding }
SmockSymbologyProvider class >> addSymbology: aKey withKeyFilePathDictionary: aDictionary [

"This require as input :
- a key from this Symbology 
- a dictionary key / filepath for symbol definition "

| symbolDic image |

"Create dictionary for key / symbol for this new Symbology"
symbolDic := Dictionary new.

"Load all symbols"
aDictionary keysDo: [:each | 
		image := (ImageReadWriter formFromStream: ( (aDictionary at:each) asFileReference binaryReadStream )).
		symbolDic at: each  put: image.
		].

"Now add the new symbology to main Symbology dictionnary"
symbologyTable ifNil: [ symbologyTable := Dictionary new ].
symbologyTable at: aKey put: symbolDic.


]

{ #category : #adding }
SmockSymbologyProvider class >> availableSymbologies [
	<script:'self availableSymbologies inspect'>

	^self symbologyTable keys
]

{ #category : #creation }
SmockSymbologyProvider class >> cleanUp: anObject [

	self cleanUpSymbologies.
]

{ #category : #adding }
SmockSymbologyProvider class >> cleanUpSymbologies [
	<script: 'self cleanUpSymbologies'>
	symbologyTable := nil.
]

{ #category : #creation }
SmockSymbologyProvider class >> getSymbologyInstance [
	^ SmockSymbologyProvider new 
]

{ #category : #adding }
SmockSymbologyProvider class >> symbologyTable [
	<script:'self symbologyTable inspect'>
	
	symbologyTable ifNil:[symbologyTable := Dictionary new].
	^symbologyTable
]

{ #category : #'services - symbology manager' }
SmockSymbologyProvider >> getCurrentSymbology [

	currentSymbology ifNil:[
		"Try to setup a default symbology"
		self class availableSymbologies notEmpty ifTrue:[
			self setCurrentSymbology: (self class availableSymbologies first).
		]. 	
	].

	^currentSymbology 
]

{ #category : #'component accessing' }
SmockSymbologyProvider >> getSmockSymbologyManagerEventsNotifier [
	^self eventsNotifiers at: SmockSymbologyManagerEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: SmockSymbologyManagerEvents name: nil].
]

{ #category : #access }
SmockSymbologyProvider >> getSymbol: aSymbolKey [

	^self getCurrentSymbology at: aSymbolKey ifAbsent:[nil].
]

{ #category : #access }
SmockSymbologyProvider >> setCurrentSymbology: aKey [

	currentSymbology := symbologyTable at: aKey.
	
	self getGeoSymbologyManagerEventsNotifier symbologyHasChanged: aKey.
	
]
