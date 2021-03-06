with accounts as  
  (SELECT c1.CustCode
        ,c1.PremCode
        ,Email PremCodeTo
        ,t1.AccountId
    FROM dbo.CisTempAccount c1,
         dbo.Account t1
   WHERE c1.CustCode = t1.CustCode
     and c1.PremCode = t1.PremCode 
     --and c1.CustCode = 1986234 
  ),
  accountEmails as
  (Select  AccountEmailId
          ,ae.AccountId
          ,EmailId
          ,IsOnlinePrimary
          ,Realm
          ,PaperlessToken
          ,TokenExpiryDate
          ,CustCode
          ,PremCode
          ,PremCodeTo
     from dbo.AccountEmail ae,
          accounts a1 
    Where ae.accountId = a1.accountId
   ),
 newAccounts as
  (SELECT c1.CustCode
         ,c1.PremCode
         ,PremCodeTo
         ,EmailId
        --,t1.AccountId
     FROM accountEmails c1
    WHERE NOT exists (select 1
                        from dbo.account a1
                       Where c1.CustCode = a1.CustCode
                         and c1.PremCodeTo = a1.PremCode)
   )
   --select CustCode,PremCodeTo from newAccounts
   --Group by CustCode,PremCodeTo
   INSERT INTO dbo.Account
           (CustCode
           ,PremCode)
          (select CustCode
                 ,PremCodeTo
             from newAccounts
            Group by CustCode,PremCodeTo)
  