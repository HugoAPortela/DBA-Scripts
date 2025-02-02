--CRIA BANCO PARA EXECU��O DE TESTES TAIL LOG
IF EXISTS (SELECT NULL FROM SYS.DATABASES WHERE NAME = 'TESTE_TAIL')
           DROP DATABASE TESTE_TAIL
CREATE DATABASE TESTE_TAIL
ON PRIMARY
(NAME='TESTE_TAIL', FILENAME='C:\temp\TESTE_TAIL\TESTE_TAIL.mdf')
LOG ON
(NAME = 'TESTE_TAIL_LOG', FILENAME = 'C:\temp\TESTE_TAIL\TESTE_TAIL_Log.ldf')
GO

BACKUP DATABASE TESTE_TAIL
    TO DISK = 'C:\temp\TESTE_TAIL\BKP_TESTE_TAIL_FULL.bak'
GO

BACKUP LOG TESTE_TAIL
    TO DISK = 'C:\temp\TESTE_TAIL\BKP_TESTE_TAIL_LOG.trn'


--E SE ACONTECER UM ACIDENTE?
SHUTDOWN WITH NOWAIT

--SOLU��O...
--BACKUP TAIL DO LOG

USE TESTE_TAIL

BACKUP LOG TESTE_TAIL
    TO DISK = 'C:\temp\TESTE_TAIL\BKP_TESTE_TAIL_LOG_TAIL.trn'
  WITH NO_TRUNCATE


RESTORE FILELISTONLY FROM DISK = 'C:\temp\TESTE_TAIL\BKP_TESTE_TAIL_FULL.bak'

--TESTE_TAIL	C:\temp\TESTE_TAIL\TESTE_TAIL.mdf
--TESTE_TAIL_LOG	C:\temp\TESTE_TAIL\TESTE_TAIL_Log.ldf

RESTORE DATABASE TESTE_TAIL
   FROM DISK = 'C:\temp\TESTE_TAIL\BKP_TESTE_TAIL_FULL.bak'
   WITH NORECOVERY
		,REPLACE

RESTORE LOG TESTE_TAIL
   FROM DISK = 'C:\temp\TESTE_TAIL\BKP_TESTE_TAIL_LOG.trn'
   WITH NORECOVERY


RESTORE LOG TESTE_TAIL
   FROM DISK = 'C:\temp\TESTE_TAIL\BKP_TESTE_TAIL_LOG_TAIL.trn'
   WITH RECOVERY
