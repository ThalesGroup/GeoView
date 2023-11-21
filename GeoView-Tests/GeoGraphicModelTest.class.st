"
A GFLModelTest is a test class for testing the behavior of GFLModel
"
Class {
	#name : #GeoGraphicModelTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - Model'
}

{ #category : #tests }
GeoGraphicModelTest >> testCreateExistingData [
	| model processData data1 gData1 data2 error |
	model := GeoViewModel new.
	model indexAccessor: #id.
	processData := GeoViewTestProcessData new.
	model setProcessData: processData for: GeoViewTestData.
	
	data1 := GeoViewTestData id: 1 data: #toto.
	gData1 := model created: data1.
	
	"Create already existing data"
	error := nil.
	data2 := GeoViewTestData id: 1 data: #tata.
	[ gData1 := model created: data2 ] on: Error do:[ :e | error := e ].
	self assert: error class equals: GeoViewDuplicateIdError.
	self assert: model datas size equals: 1. 
]

{ #category : #tests }
GeoGraphicModelTest >> testCreateUpdateDeleteIndexedDatas [
	| model processData data1 gData1 |
	model := GeoViewModel new.
	model indexAccessor: #id.
	processData := GeoViewTestProcessData new.
	model setProcessData: processData for: GeoViewTestData.
	
	self assert: model processDatas size equals: 1.
	self assert: (model getProcessDataFor: GeoViewTestData) equals: processData.
	
	"Create"
	data1 := GeoViewTestData id: 1 data: #toto.
	gData1 := model created: data1.
	
	self assert: model datas size equals: 1.
	self assert: gData1 equals: #toto. "defined in process data created"
	
	"Update"
	data1 data: #tata.
	gData1 := model updated: data1.
	
	self assert: model datas size equals: 1.
	self assert: gData1 equals: #tata. "defined in process data created"
	
	"Delete"
	model deleted: data1.
	self assert: model datas size equals: 0.
]

{ #category : #tests }
GeoGraphicModelTest >> testCreateUpdateDeleteIndexedDatasWithDefaultIndexAccessor [
	| model processData data1 gData1 |
	model := GeoViewModel new.
	processData := GeoViewTestProcessData new.
	model setProcessData: processData for: GeoViewTestData.
	
	self assert: model processDatas size equals: 1.
	self assert: (model getProcessDataFor: GeoViewTestData) equals: processData.
	
	"Create"
	data1 := GeoViewTestData id: 1 data: #toto.
	gData1 := model created: data1.
	
	self assert: model datas size equals: 1.
	self assert: gData1 equals: #toto. "defined in process data created"
	
	"Update"
	data1 data: #tata.
	gData1 := model updated: data1.
	
	self assert: model datas size equals: 1.
	self assert: gData1 equals: #tata. "defined in process data created"
	
	"Delete"
	model deleted: data1.
	self assert: model datas size equals: 0.
]

{ #category : #tests }
GeoGraphicModelTest >> testCreateUpdateDeleteIndexedDatasWithDefaultProcessData [
	| model processData data1 gData1 |
	model := GeoViewModel new.
	processData := GeoViewTestProcessData new.
	model defaultProcessData: processData.
	
	self assert: model processDatas size equals: 0.
	self assert: (model getProcessDataFor: GeoViewTestData) equals: nil.
	self assert: (model defaultProcessData) equals: processData.
	
	"Create"
	data1 := GeoViewTestData id: 1 data: #toto.
	gData1 := model created: data1.
	
	self assert: model datas size equals: 1.
	self assert: gData1 equals: #toto. "defined in process data created"
	
	"Update"
	data1 data: #tata.
	gData1 := model updated: data1.
	
	self assert: model datas size equals: 1.
	self assert: gData1 equals: #tata. "defined in process data created"
	
	"Delete"
	model deleted: data1.
	self assert: model datas size equals: 0.
]

{ #category : #tests }
GeoGraphicModelTest >> testCreateUpdateDeleteNonExistingData [
	| model processData data1 gData1 error |
	model := GeoViewModel new.
	model indexAccessor: #id.
	processData := GeoViewTestProcessData new.
	model setProcessData: processData for: GeoViewTestData.
	error := nil.
	
	"Update non existing data"
	data1 := GeoViewTestData id: 1 data: #toto.
	[ gData1 := model updated: data1 ] on: Error do:[ :e | error := e ].
	self assert: error class equals: GeoViewNoIdError.
	self assert: model datas size equals: 0.

	"Delete non existing data"
	error := nil.
	[ gData1 := model deleted: data1 ] on: Error do:[ :e | error := e ].
	self assert: error class equals: GeoViewNoIdError.
	self assert: model datas size equals: 0.
]

{ #category : #tests }
GeoGraphicModelTest >> testInitialize [
	| model |
	model := GeoViewModel new.

	self assert: model datas isEmpty.
	self assert: model isRecyclingActive.
	self assert: model processDatas isEmpty.
	self assert: model recycledDatasStack isEmpty.
	self assert: model indexAccessor equals: #key.
	self assert: model defaultProcessData isNil.
]

{ #category : #tests }
GeoGraphicModelTest >> testMultiCreateUpdateDeleteIndexedDatas [
	| model processData userModel |
	model := GeoViewModel new.
	model indexAccessor: #id.
	processData := GeoViewTestProcessData new.
	model setProcessData: processData for: GeoViewTestData.
	userModel := OrderedCollection new.
	
	"Create"
	1 to: 100 do:[ :i | | data |
		data := GeoViewTestData id: ('data', i printString) asSymbol data: i.
		userModel add: data.
		model created: data.
	].
	self assert: model datas size equals: 100.

	1 to: 100 do:[ :i | | gData |
		gData := model getData: ('data', i printString) asSymbol. 
		self assert: gData = i. "defined in process data created"
	].

	"Update"
	1 to: 100 do:[ :i | | data |
		data := userModel at: i.
		data data: (i + 1).
		model updated: data.
	].
	self assert: model datas size equals: 100.

	1 to: 100 do:[ :i | | gData |
		gData := model getData: ('data', i printString) asSymbol. 
		self assert: gData = (i + 1). "defined in process data updated"
	].

	"Delete"
	1 to: 100 do:[ :i | | data |
		data := userModel at: i.
		model deleted: data.
	].
	self assert: model datas size equals: 0.
]
