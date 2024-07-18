# Flipp Platform SDK Sample App

This README describes how you can integrate with the Flipp Platform SDK. 

> [!WARNING]
> **This sample app uses the alpha version of the Flipp Platform SDK. The features and delegate methods are currently hardcoded.**

## Table of Contents
- [About the SDK](#about)
- [Quick Start](#quick-start)
- [Methods](#methods)
- [Delegate Methods](#delegate-methods)

## About the SDK <a name="about"></a>
The Flipp Platform SDK allows mobile retailer apps to render flyers in two formats: in traditional print form or in a digital publication form. 

The digital publication format renders offers in a dynamic way that maintains responsiveness and merchandising flexibility, while also providing a host of features to allow users to interact with flyer offers.

## Quick Start <a name="quick-start"></a>

## Methods <a name="methods"></a>
The Flipp Platform SDK currently provides the following features:

### initialize

### fetchPublicationsList

### createRenderingView

### updateUserId


## Delegate Methods <a name="delegate-methods"></a>
The Flipp Platform SDK can send events notifying your app about actions that the user has taken. 
The following events are supported:

`func didTap(item: String)` - This method will be called by the SDK to notify your app if a user has tapped on a publication offer and will return offer data.


