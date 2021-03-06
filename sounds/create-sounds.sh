#!/bin/bash
#
# create soundfiles for telephony applications
#
# Author: Ben Fuhrmannek <bef@eventphone.de>
# Date: 2012-10-12
#
# Copyright (c) 2012, Ben Fuhrmannek
# All rights reserved.
#
# NOTE: Generated sound files may have a restrictive license, e.g. voices
#       generated by mac's "say" command.
#

function checkfn() {
	if [ ! -d `dirname $1` ]; then
		mkdir -p `dirname $1`
	fi
	return `test ! -f $1.slin`
}
function createsnd() {
	checkfn $1 || return
	echo "[+] $1: $2"
	## mac
	say -v $VOICE -o $1.tmp.wav --file-format=WAVE --data-format=LEI16 --channels=1 "$2"
	sox $1.tmp.wav $1.wav trim 0 -0:00.22
	rm $1.tmp.wav
	sox $1.wav -t raw -r 8000 -c 1 -e signed-integer $1.slin
	## linux/other
	#espeak  -v en-uk -z --stdout $2 |sox -t wav - -t raw -r 8000 -c 1 -e signed-integer $1.slin
}

## some checks first
which sox >/dev/null
if [ ! $? ]; then
	echo "ERROR: need sox"
	exit 1
fi
if [ ! -w . ]; then
	echo "ERROR: current directory must be writable"
	exit 1
fi

###########################################################
## English
VOICE=Daniel

## digits
for i in {0..23} 30 40 50 60 70 80 90 and hundred thousand million minus oclock hash asterisk; do
	createsnd digits/$i $i
done

## NATO phonetic alphabet
for i in alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike november oscar papa quebec romeo sierra tango uniform victor whiskey xray yankee zulu; do
	createsnd phonetic/${i:0:1} $i
done

## letters
for i in {a..z} dollar dash percent slash equals comma fullstop; do
	createsnd letters/$i $i
done

## silence
for i in 100 150 200 250 300 400 500 600 700 750 800 900; do
	fn=silence/${i}u
	checkfn $fn || continue
	echo "[+] $fn"
	sox -n -t raw -r 8000 -c 1 -e signed-integer ${fn}.slin trim 0 0:00.$i
done
for i in {1..10}; do
	fn=silence/${i}s
	checkfn $fn || continue
	echo "[+] $fn"
	sox -n -t raw -r 8000 -c 1 -e signed-integer ${fn}.slin trim 0 0:`printf %02d $i`
done

## words and phrases
createsnd enter-password "please enter your password, followed by the pound key"
createsnd goodbye goodbye
createsnd t-magic "there is no such thing as magic"
createsnd time time
createsnd welcome welcome
createsnd utc utc
createsnd im-sorry "i am sorry"
createsnd conference-unavailable "this conference is currently unavailable"
createsnd please-try-again-later "please try again later"
createsnd please-enter-your-access-code "please enter your access code, followed by the pound key"
createsnd press-snom-reboot "please press star star hash hash"


###########################################################
## Deutsch
VOICE=Anna

## digits
for i in {0..23} 30 40 50 60 70 80 90 und hundert tausend million millionen minus uhr; do
	createsnd de/digits/$i $i
done
createsnd de/digits/hash raute
createsnd de/digits/asterisk stern

## German phonetic alphabet
for i in anton berta caesar dora emil friedrich gustav heinrich ieda julius kaufmann ludwig martha nordpol otto paula quelle richard siegfried theodor ulrich viktor wilhelm xanthippe ypsilon zeppelin; do
	createsnd de/phonetic/${i:0:1} $i
done

## letters
for i in {a..z} dollar; do
	createsnd de/letters/$i $i
done
createsnd de/letters/dash Bindestrich
createsnd de/letters/percent Prozent
createsnd de/letters/slash Schraegstrich
createsnd de/letters/equals Istgleich
createsnd de/letters/comma Komma
createsnd de/letters/fullstop Punkt

## words and phrases
#createsnd de/foo foo

