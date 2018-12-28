#!/usr/bin/env python
#coding:utf-8

import os
import sys

def write_stdout(s):
    sys.stdout.write(s)
    sys.stdout.flush()

def write_stderr(s):
    sys.stderr.write(s)
    sys.stderr.flush()

def send(data):
    host = 'https://notify-api.line.me/api/notify'
    token = 'ORW9pgorEhyTMXnbmENXsCXwvQKkMKELzvJSqJnHAIM'
    os.system('curl -H "Authorization: Bearer %s" -d "message=%s" %s' % (token, data, host))

def main():
    while 1:
        write_stdout('READY\n') # transition from ACKNOWLEDGED to READY
        line = sys.stdin.readline()
        write_stderr(line)
        headers = dict([ x.split(':') for x in line.split() ])
        data = sys.stdin.read(int(headers['len']))
        write_stderr(data)
        send(data)
        write_stdout('RESULT 2\nOK') # transition from READY to ACKNOWLEDGED

if __name__ == '__main__':
    main()
