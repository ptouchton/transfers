--update with existing AccountEmailRow
With accounts as
 (SELECT c1.CustCode
        ,c1.PremCode
        ,Email PremCodeTo
        ,t1.AccountId
    FROM dbo.CisTempAccount c1,
         dbo.Account t1
   WHERE c1.CustCode = t1.CustCode
     and c1.PremCode = t1.PremCode
     --and c1.CustCode = 1532887
     --and c1.PremCode = '714870'
 ),
delAccountEmails as
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
      and len(Realm) > 0
  )    
  --select * From dbo.AccountEmail
  --  Where AccountEmailId IN 
  --                         (select AccountEmailId from delAccountEmails)
  --order by AccountId
  
  DELETE From dbo.AccountEmail
    Where AccountEmailId IN 
                           (select AccountEmailId from delAccountEmails)
