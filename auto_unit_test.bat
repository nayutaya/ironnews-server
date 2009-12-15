@echo off
set MODEL=%1
ifchanged app\models\%MODEL%.rb test\unit\%MODEL%_test.rb -d "ruby test\unit\%MODEL%_test.rb"
