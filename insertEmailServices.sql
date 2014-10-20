--insert email Services for new AccountEmail rows
WITH updateAccountEmails as
 (select AccountEmailId,
         AccountId
   from dbo.AccountEmail ae
  Where Len(ae.Realm) > 0
    and ae.AccountEmailId NOT IN
                       (select aes.AccountEmailId
                         from dbo.AccountEmailService aes
                         Where aes.AccountEmailId = aes.AccountEmailId)
 )
 --select * from updateAccountEmails
 INSERT INTO EmailServices.dbo.AccountEmailService
           (AccountId
            ,EmailServiceTypeId
           ,AccountEmailId)
     ( SELECT AccountId
              ,1
              ,AccountEmailId
         FROM updateAccountEmails
     )    
