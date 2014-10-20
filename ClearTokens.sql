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
 )
  select * 
   from fromAccountEmail
  Where IsNull(Realm,'X') = 'X'
    and TokenExpiryDate >= GetDate()
