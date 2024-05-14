#!/bin/bash
exec uftrace record -P mcount -d /traces/uftrace.data redis-server --protected-mode no
