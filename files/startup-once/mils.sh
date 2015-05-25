#!/bin/bash
sudo sed -i -e 's/ \(stable \|wheezy \)/ testing /ig' /etc/apt/sources.list;
