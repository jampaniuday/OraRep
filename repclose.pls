  -- Page Ending
  print(TABLE_OPEN);
  L_LINE := '<TR><TD><DIV CLASS="small">Created by OraRep v'||SCRIPTVER||' &copy; 2003-2004 by '||
	    '<A HREF="http://www.qumran.org/homes/izzy/" TARGET="_blank">Itzchak Rehberg</A> '||
            '&amp; <A HREF="http://www.izzysoft.de" TARGET="_blank">IzzySoft</A></DIV></TD></TR>';
  print(L_LINE);
  print(TABLE_CLOSE);
  print('</BODY></HTML>');

END;
/

SPOOL off
