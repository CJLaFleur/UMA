#!/bin/bash

profile=($1)
api_key=($2)
maas login $profile http://localhost:5240/MAAS/api/2.0/ - < $api_key
