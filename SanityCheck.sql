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
fromAccountEmail as
  (select a1.PremCodeTo
          ,a1.CustCode
          ,a1.PremCode
          ,ae.*
     from dbo.AccountEmail ae,
          accounts a1
    Where a1.AccountId = ae.AccountId
      --and a1.CustCode = ae.CustCode
 ),
 toAccounts as
 (SELECT c1.CustCode
        ,c1.PremCode
        ,PremCodeTo
        ,t1.AccountId
    FROM fromAccountEmail c1, 
         dbo.Account t1
   WHERE c1.CustCode = t1.CustCode
     and c1.PremCodeTo = t1.PremCode
 ) ,   
 toAccountEmail as     
  (select ae.*
    from toAccounts t1
        ,dbo.AccountEmail ae
        ,fromAccountEmail fae
   Where t1.AccountId = ae.AccountId
     and fae.EmailId = ae.EmailId
  ) 
  --select * from fromAccountEmail
  select *
   from fromAccountEmail fae
  Where NOT EXISTS  (Select t1.AccountEmailId
                                     from toAccountEmail t1
                                    Where t1.EmailId = fae.EmailId)
