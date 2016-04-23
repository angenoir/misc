#!/bin/bash

sqlplus user/password@ORACLE_BC <<eof
SELECT SUM(BYTES)/1024/1024/1024 FROM DBA_FREE_SPACE WHERE TABLESPACE_NAME = 'BC_DATA' GROUP BY TABLESPACE_NAME;
eof


