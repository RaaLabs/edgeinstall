#!/bin/bash

echo 'ansible ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo
echo 'dolittle ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo