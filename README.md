# SnakeDCI

This repository is a supplement to the [haxedci](https://github.com/ciscoheat/haxedci) library for [Haxe](http://haxe.org). It shows the power of DCI in a larger example, by creating the classic Snake game in Haxe using DCI and the [Phaser](https://phaser.io/) game library.

If you want to see the result straight away, [it's available online here](https://ciscoheat.github.io/snakedci/). Use the cursor keys to control the snake.

The most important aspect of SnakeDCI however, is not to show a simple game, it's to show how well DCI maps to [Use Cases](http://en.wikipedia.org/wiki/Use_case). You should refer to [this spreadsheet](https://docs.google.com/spreadsheets/d/1TkDFiUyfZyjQWsxLUponRIe8s0_4fABm-SJ7IjBkKKA/edit#gid=2) when looking at the [Context classes](https://github.com/ciscoheat/SnakeDCI/tree/master/src/contexts). Note how the source code reflects the specification.

## How to use

You will need [Haxe 4](https://haxe.org/download/version/4.0.0-preview.4/) and [Node.js](https://nodejs.org/). After cloning or downloading this repository, install some build tools with `npm run tools`, then use `npm start` for automatic reloading when recompiling.

Use `haxe build.hxml` for compiling, or even better, [VS Code](https://code.visualstudio.com/).

## What is DCI?

DCI stands for Data, Context, Interaction. One of the key aspects of DCI is to separate what a system *is* (data) from what it *does* (function). Data and function has very different rates of change so they should be separated, not as it currently is, put in classes together. But DCI is so much more, so please explore the resources below. If you are familiar with Haxe already, the [haxedci library](https://github.com/ciscoheat/haxedci) is a good start.

## DCI Resources

Website - [fulloo.info](http://fulloo.info) <br>
FAQ - [DCI FAQ](http://fulloo.info/doku.php?id=faq) <br>
Support - [stackoverflow](http://stackoverflow.com/questions/tagged/dci), tagging the question with **dci** <br>
Discussions - [Object-composition](https://groups.google.com/forum/?fromgroups#!forum/object-composition) <br>
Wikipedia - [DCI entry](http://en.wikipedia.org/wiki/Data,_Context,_and_Interaction) <br>
Haxe/DCI library with tutorial - [haxedci](https://github.com/ciscoheat/haxedci)

## Credits

A big thanks to Blank101 for the [phaser externs](https://github.com/Blank101/haxe-phaser)!
