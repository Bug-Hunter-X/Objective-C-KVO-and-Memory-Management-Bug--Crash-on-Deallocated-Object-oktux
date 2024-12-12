# Objective-C KVO and Memory Management Bug

This repository demonstrates a common yet subtle bug in Objective-C related to Key-Value Observing (KVO) and memory management.  Specifically, it showcases the potential for crashes when an object is deallocated while still being observed, particularly when using weak references.

## The Problem

The `bug.m` file contains code that illustrates the issue.  Failure to remove an observer from an object before it's deallocated leads to undefined behavior and a potential crash.

## The Solution

The `bugSolution.m` file provides a corrected version of the code.  It demonstrates the proper way to handle KVO and memory management by ensuring that observers are removed before the observed object is deallocated.