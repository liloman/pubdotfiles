#!/usr/bin/env bash
#Stuff to do on logout

#Stop current taskwarrior task
task +ACTIVE stop

#syncronize tasks
task sync


