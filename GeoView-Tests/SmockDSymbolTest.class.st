Class {
	#name : #SmockDSymbolTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - DShape'
}

{ #category : #tests }
SmockDSymbolTest >> testCopy [ 
	
	| dShape dShapeCopy |
	dShape := SmockDSymbol new.
	dShapeCopy := dShape copy.
	
	self assert: dShapeCopy equals: dShape.
	self assert: (dShapeCopy == dShape) equals: false.
]

{ #category : #tests }
SmockDSymbolTest >> testInitialize [ 
	
	| dShape |
	dShape := SmockDSymbol new.
	
	self assert: dShape symbolKey equals: nil.
	self assert: dShape orientation equals: nil.
]

{ #category : #tests }
SmockDSymbolTest >> testOrientation [
	
	| dShape |
	dShape := SmockDSymbol new.

	dShape orientation: 180.
	self assert: dShape orientation equals: 180.
	
	dShape orientation: nil.
	self assert: dShape orientation equals: nil.
]

{ #category : #tests }
SmockDSymbolTest >> testSymbolKey [ 
	
	| dShape |
	dShape := SmockDSymbol new.

	dShape symbolKey: #mySymbol.
	self assert: dShape symbolKey equals: #mySymbol.
	
	dShape symbolKey: nil.
	self assert: dShape symbolKey equals: nil.
]
