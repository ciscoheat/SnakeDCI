# SnakeDCI

This repository is a supplement to the [haxedci](https://github.com/ciscoheat/haxedci) library for [Haxe](http://haxe.org). It shows the power of DCI in a larger example than the basic [Money Transfer](https://github.com/ciscoheat/haxedci-example), by creating the classic Snake game in Haxe using DCI and the [HaxeFlixel](http://haxeflixel.com/) game library.

The most important aspect of SnakeDCI is to show how well DCI maps to [Use Cases](http://en.wikipedia.org/wiki/Use_case). You should refer to [Use cases.md](https://github.com/ciscoheat/SnakeDCI/blob/master/Use%20cases.md) when looking at the [Context classes](https://github.com/ciscoheat/SnakeDCI/tree/master/src/contexts). Note how the source code reflects the specification.

## How to use
First of course, download and install [Haxe](http://haxe.org). Then clone this repository or download it, and open the [FlashDevelop](http://www.flashdevelop.org/) project file, or execute run.bat to build and run.

You also need to execute the following haxelib commands in a command prompt to run SnakeDCI:

**haxelib install haxedci** <br>
**haxelib install flixel**

(If you already have the above libraries installed, make sure you update them to the latest version.)

## What is DCI?
DCI stands for Data, Context, Interaction. One of the key aspects of DCI is to separate what a system *is* (data) from what it *does* (function). Data and function has very different rates of change so they should be separated, not as it currently is, put in classes together. But DCI is so much more, so please explore the resources below. If you are familiar with Haxe already, the [haxedci-example](https://github.com/ciscoheat/haxedci-example) is a good start.

## DCI Resources
Website - [fulloo.info](http://fulloo.info) <br>
FAQ - [DCI FAQ](http://fulloo.info/doku.php?id=faq) <br>
Support - [stackoverflow](http://stackoverflow.com/questions/tagged/dci), tagging the question with **dci** <br>
Discussions - [Object-composition](https://groups.google.com/forum/?fromgroups#!forum/object-composition) <br>
Wikipedia - [DCI entry](http://en.wikipedia.org/wiki/Data,_Context,_and_Interaction) <br>
Haxe/DCI tutorial - [haxedci-example](https://github.com/ciscoheat/haxedci-example)

## Credits
Game based on [FlxSnake](from https://github.com/HaxeFlixel/flixel-demos/tree/dev/Arcade%20Classics/FlxSnake) in the HaxeFlixel demos. Thanks!
