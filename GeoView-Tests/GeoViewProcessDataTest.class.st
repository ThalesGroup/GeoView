"
A ProcessDataTest is a test class for testing the behavior of ProcessData
"
Class {
	#name : #GeoViewProcessDataTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - Model'
}

{ #category : #tests }
GeoViewProcessDataTest >> testInitialize [

	| processData |
	processData := GeoViewTestProcessData new.
	
	self assert: processData processor isNil.
	self assert: processData properties isEmpty.
]

{ #category : #tests }
GeoViewProcessDataTest >> testProperty [

	| processData |
	processData := GeoViewTestProcessData new.
	
	processData setProperty: #toto value: #tata. 
	self assert: processData properties size equals: 1.
	self assert: (processData isPropertyExists: #toto) equals: true.
	self assert: (processData getProperty: #toto) equals: #tata.
	
	processData setProperty: #toto value: #tutu.
	self assert: processData properties size equals: 1.
	self assert: (processData isPropertyExists: #toto) equals: true.
	self assert: (processData getProperty: #toto) equals: #tutu.
	
	processData removeProperty: #toto.
	self assert: (processData isPropertyExists: #toto) equals: false.
	self assert: (processData getProperty: #toto) equals: nil.
	self assert: processData properties isEmpty.
]
