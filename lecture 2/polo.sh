#!/bin/bash
polo() {
	echo "in polo we started in directory $(pwd)"
	cd $dir || exit
	echo "but then it takes us back to the marco directory $(pwd)"
}
