"
A GeoViewInfosTest is a test class for testing the behavior of GeoViewInfos
"
Class {
	#name : #GeoViewInfosTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - Core'
}

{ #category : #tests }
GeoViewInfosTest >> testInitialize [

	| infos |
	infos := GeoViewInfos new.
	self assert: infos extent equals: 0@0.
	self assert: infos origin equals: 0@0.
	self assert: infos center equals: 0@0.
	self assert: infos width equals: 0.
	self assert: infos height equals: 0.
]

{ #category : #tests }
GeoViewInfosTest >> testupdate [

	| infos |
	infos := GeoViewInfos new.
	infos update.
]
