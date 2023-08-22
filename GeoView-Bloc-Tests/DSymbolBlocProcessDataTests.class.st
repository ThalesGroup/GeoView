Class {
	#name : #DSymbolBlocProcessDataTests,
	#superclass : #GeoAbstractDShapeBlocProcessDataTests,
	#instVars : [
		'dSymbol'
	],
	#category : #'GeoView-Bloc-Tests-Cases - ProcessData'
}

{ #category : #running }
DSymbolBlocProcessDataTests >> createProcessor [
	| processor symbology |
	processor := super createProcessor.  
	
	symbology := Dictionary new.
	symbology at: #testSymbolA put: (Form extent: 50@50).
	symbology at: #testSymbolB put: (Form extent: 50@50).
	GeoSymbologyProvider addSymbology: #testSymbology imageDictionary: symbology.	
	
	processor symbologyProvider: GeoSymbologyProvider new.
	^processor
]

{ #category : #running }
DSymbolBlocProcessDataTests >> dShape [

	^ DSymbol new
		key: 1;
		symbolKey: nil;
		yourself.
]

{ #category : #running }
DSymbolBlocProcessDataTests >> processData [

	^ DSymbolBlocProcessData  
]

{ #category : #running }
DSymbolBlocProcessDataTests >> setUp [
	GeoSymbologyProvider cleanUpSymbologies.
	super setUp.
]

{ #category : #running }
DSymbolBlocProcessDataTests >> tearDown [
	super tearDown.
	GeoSymbologyProvider cleanUpSymbologies.
]

{ #category : #tests }
DSymbolBlocProcessDataTests >> testProcessCUDDataIncomingWithContext [
	| blElement |
	dSymbol := self dShape.
	blElement := process processCreatedData: dSymbol key incoming: dSymbol with: nil context: nil.
	self assert: blElement background notNil.
	self assert: blElement background image equals: nil.
	
	dSymbol symbolKey: #testSymbolA.
	blElement := process processUpdatedData: dSymbol key incoming: dSymbol with: blElement context: nil.
	self assert: blElement background notNil.
	self assert: blElement background image notNil.

	blElement := process processDeletedData: dSymbol key incoming: dSymbol with: blElement context: nil.
	self assert: blElement notNil.
]
