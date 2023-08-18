Class {
	#name : #GeoSymbologyProviderTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - Symbology'
}

{ #category : #tests }
GeoSymbologyProviderTest >> testSymbologyCreation [

"Create a new Symbology"
| symbolDict sym |
symbolDict := Dictionary new.
symbolDict at: #key1 put: 'g:\tas\Maquettage\Atelier\SMOCK\Pharo\Generation image Thales\logo_noir_transparent.png'.
symbolDict at: #key2 put: 'g:\tas\Maquettage\Atelier\SMOCK\Pharo\postcard.png'.

GeoSymbologyProvider	addSymbology: #SymTest withKeyFilePathDictionary: symbolDict.
	
sym := GeoSymbologyProvider getSymbologyInstance.

sym setCurrentSymbology: #SymTest.

self deny: (sym getSymbol: #key1) equals: nil


]
