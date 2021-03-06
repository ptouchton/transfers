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
          ,ae.Realm newRealm
          ,ae.IsOnlinePrimary newIsOnlinePrimary
          ,ae.AccountEmailId toAccountEmailId
    from toAccounts t1
        ,dbo.AccountEmail ae
   Where t1.toAccountId = ae.AccountId
     and t1.EmailId = ae.EmailId
     and IsNull(ae.Realm,0) != IsNull(t1.Realm,0)
     and len(t1.Realm) > 0
     and IsNull(ae.Realm,'S') = 'S'
  )
  --select * 
  --  from toAccountEmails t1
  -- order by CustCode
  Update dbo.AccountEmail
     set IsOnlinePrimary = t1.IsOnlinePrimary
         ,Realm = t1.Realm
         ,PaperlessToken = t1.PaperlessToken
         ,TokenExpiryDate = t1.TokenExpiryDate
    From toAccountEmails t1
   Where AccountEmail.AccountEmailId = t1.toAccountEmailId
   
    