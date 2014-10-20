--update with updating the AE row with the toPrem accountId
With accounts as
 (SELECT c1.CustCode
        ,c1.PremCode
        ,Email PremCodeTo
        ,t1.AccountId
    FROM dbo.CisTempAccount c1,
         dbo.Account t1
   WHERE c1.CustCode = t1.CustCode
     and c1.PremCode = t1.PremCode
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
toAccounts as
  (select  AccountEmailId
          ,ae.AccountId
          ,EmailId
          ,IsOnlinePrimary
          ,Realm
          ,PaperlessToken
          ,TokenExpiryDate
          ,ae.CustCode 
          ,ae.PremCode
          ,a1.CustCode ToCustCode
          ,a1.PremCode ToPremCode
          ,PremCodeTo
          ,a1.AccountId toAccountId
     from dbo.account a1,
          accountEmails ae
    Where a1.PremCode = ae.PremCodeTo
      and a1.CustCode = ae.CustCode
  ),
 toAccountEmails as     
  (select t1.*
          ,ae.AccountEmailId toAccountEmailId
          ,ae.Realm toRealm
          ,ae.IsOnlinePrimary toOnlinePrimary
    from toAccounts t1
        ,dbo.AccountEmail ae
   Where t1.toAccountId = ae.AccountId
     and t1.EmailId = ae.EmailId
  ),
 updateAccountEmails as 
  (select *
   from toAccounts t1
    Where t1.AccountEmailId NOT IN(Select ae.AccountEmailId
                                     from toAccountEmails ae
                                    Where t1.AccountEmailId = ae.AccountEmailId) 
  )
 --select t1.* 
 --  from updateAccountEmails t1
 --      ,dbo.AccountEmail
 --Where AccountEmail.AccountEmailId = t1.AccountEmailId                                          
Update dbo.AccountEmail
     set AccountId = toAccountId
    From updateAccountEmails t1
   Where AccountEmail.AccountEmailId = t1.AccountEmailId                                    
   
