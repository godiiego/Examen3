     FDATOS1P   UF A E           K DISK
     FTSTF06P   UF A E           K DISK
      //FTSTF05P   UF A E           K DISK
     DA                S              2S 0
     DB                S              2S 0
     DC                s              2S 0
     DD                S              2S 0
     DISODate          S               D   DATFMT(*ISO)
       // Programa principal
       /free
           READ DATOS1P;
           DOW NOT %EOF() AND SITUAC >0;
            EXSR SR01;
            EXSR CALFLMESP;

            F6TARJ=TARJET;
            F6SITU=SITUAC;
            F6BIN=%SUBST(TARJET:1:6);
            F6CVEN=%CHAR(CAPV00 + CAPV01 + CAPV02);
            F6CXVN = %CHAR(PVEC00+PVEC01+PVEC02);
            F6CTOT = (%FLOAT(F6CVEN)) + (%FLOAT(F6CXVN));
            F6VSIT = F6CTOT/F6MESP;
            ISODate =%DATE();
            F6FFIN =%CHAR(ISODate+(%days(CARDIA)));
            F6DPRM =%DIFF(%DATE(F6FFIN):%DATE(FECPRO):*DAYS);

            READ DATOS1P;
            WRITE RTSTF06P;


           ENDDO;


          *inlr = *on;

          // Subrutina para calcular apellido y primer nombre:
          BEGSR SR01;
            A=%SCAN(' ':CLIENT);
            B=%SCAN(' ':CLIENT:A+1);
            C=%SCAN(' ':CLIENT:B+1);
            D=(%LEN(CLIENT))-1;

            IF C>0;
              IF C=B+1;
                F6NOMB = %SUBST(CLIENT:A:(B-A));
              else;
              F6NOMB=%SUBST(CLIENT:B:(C-B));
              ENDIF;
            ELSE;
              F6NOMB=%SUBST(CLIENT:B:(D-B));
            ENDIF;
            F6APEL=%SUBST(CLIENT:1:A);
          ENDSR;

          // Calcula el FLMESP
          BEGSR CALFLMESP;
            SELECT;
              WHEN CARDIA >= 1 AND CARDIA <=30;
                F6MESP = 02;
              WHEN CARDIA >= 31 AND CARDIA <=60;
                F6MESP = 04;
              WHEN CARDIA >= 61 AND CARDIA <=90;
                F6MESP = 10;
              WHEN CARDIA >= 91 AND CARDIA <=120;
                F6MESP = 11;
              WHEN CARDIA >= 121 AND CARDIA <=150;
                F6MESP = 12;
              WHEN CARDIA >150 OR CARDIA <=0;
                F6MESP = 99;
            ENDSL;
          ENDSR;


       /end-free                                  
