#!/usr/bin/env bash
if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q yes; then
  printf '{"text":" ","class":"muted"}'
else
  printf '{"text":"","class":"enabled"}'
fi
