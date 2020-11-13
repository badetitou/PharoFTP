Class {
	#name : #BaselineOfPharoFTP,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoFTP
}

{ #category : #baselines }
BaselineOfPharoFTP >> baseline: spec [
	<baseline>
	self defineDependencies: spec.
	self definePackages: spec.
	self defineGroups: spec
]

{ #category : #baselines }
BaselineOfPharoFTP >> defineDependencies: spec [
]

{ #category : #baselines }
BaselineOfPharoFTP >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfPharoFTP >> definePackages: spec [
	spec
		package: 'FTP';
		package: 'FTP-Tests' with: [ spec requires: #('FTP') ];
		package: 'FTP-ExternalIDE' with: [ spec requires: #('FTP') ];
		package: 'FTP-Tonel' with: [ spec requires: #('FTP') ];
		package: 'FTP-FileSystem' with: [ spec requires: #('FTP') ]
]
