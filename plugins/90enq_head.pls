
  FUNCTION have_enqs RETURN BOOLEAN IS
    BEGIN
      RETURN have_xxx('v$enqueue_stat','eq_type','cum_wait_time > 0');
    EXCEPTION
      WHEN OTHERS THEN RETURN FALSE;
    END;

  PROCEDURE P_90enqs IS
    CURSOR C_90enqs IS
      SELECT eq_type etype,
             TO_CHAR(total_req#,'999,999,999,990') totreq,
	     TO_CHAR(total_wait#,'999,999,990') totwait,
	     TO_CHAR(succ_req#,'999,999,999,990') succreq,
	     TO_CHAR(failed_req#,'999,999,999,990') failreq,
	     TO_CHAR(cum_wait_time,'999,999,999,990') cumwait
        FROM v$enqueue_stat
       WHERE cum_wait_time >0
       ORDER BY cum_wait_time DESC;

    BEGIN
      L_LINE := TABLE_OPEN||'<TR><TH COLSPAN="6"><A NAME="waitobj">Enqueue Waits'||
                '</A>&nbsp;<A HREF="JavaScript:popup('||CHR(39)||'enqwaits'||CHR(39)||
		')"><IMG SRC="/icons/unknown.gif" BORDER="0" HEIGTH="12" '||
		'VALIGN="middle"></A></TH></TR>';
      print(L_LINE);
      L_LINE := ' <TR><TD COLSPAN="6"><DIV ALIGN="center">The following queues '||
                'caused waits during the recent uptime of this instance.<BR>'||
		'Ordered by cumulative wait time (desc)';
      print(L_LINE);
      L_LINE := '</DIV></TD></TR>';
      print(L_LINE);
      L_LINE := ' <TR><TH CLASS="th_sub">Queue</TH><TH CLASS="th_sub">'||
                'Total Requests</TH><TH CLASS="th_sub">Total Waits</TH>'||
		'<TH CLASS="th_sub">Succ.Requests</TH>';
      print(L_LINE);
      L_LINE := '<TH CLASS="th_sub">Failed Req.</TH><TH CLASS="th_sub">'||
		'Cum.WaitTime</TH></TR>';
      print(L_LINE);
      FOR rec IN C_90enqs LOOP
        L_LINE := ' <TR><TD>'||rec.etype||'</TD><TD ALIGN="right">'||
                  rec.totreq||'</TD><TD ALIGN="right">'||rec.totwait||
		  '</TD><TD ALIGN="right">'||rec.succreq;
        print(L_LINE);
	L_LINE := '</TD><TD ALIGN="right">'||rec.failreq||'</TD><TD ALIGN="right">'||
                  rec.cumwait||'</TD></TR>';
        print(L_LINE);
      END LOOP;
      L_LINE := TABLE_CLOSE;
      print(L_LINE);
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;

