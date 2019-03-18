#!/bin/bash

profile=($1)
maas $profile machines accept-all
