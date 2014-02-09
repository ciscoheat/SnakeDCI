@echo off
echo Building project...
haxelib run openfl build application.xml neko -debug
echo Starting up!
bin\windows\neko\bin\SnakeDCI.exe
