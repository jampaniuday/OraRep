  -- Page Ending
  print(TABLE_OPEN);
  L_LINE := '<TR><TD><IMG SRC="w3c.jpg" ALT="w3c" WIDTH="14" HEIGHT="14"'||
            ' ALIGN="middle" STYLE="margin-right:3px"><SPAN CLASS="small">';
  print(L_LINE);
  L_LINE := 'Created by OraRep v'||SCRIPTVER||' &copy; 2003-2007 by '||
	    'Itzchak Rehberg '||
            '&amp; <A HREF="http://www.izzysoft.de" TARGET="_blank">IzzySoft</A></SPAN>';
  print(L_LINE);
  L_LINE := '<IMG SRC="islogo.gif" ALT="IzzySoft" WIDTH="14" HEIGHT="14"'||
            ' ALIGN="middle" STYLE="margin-left:3px"></TD></TR>';
  print(L_LINE);
  print(TABLE_CLOSE);
  print('</BODY></HTML>');

END;
/

SPOOL off
