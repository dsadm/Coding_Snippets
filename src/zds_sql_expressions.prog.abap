*&---------------------------------------------------------------------*
*& Report zds_sql_expressions
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_sql_expressions.

select from demo_expressions
   fields id,
          num1,
          num2,
          cast( num1 as fltp ) / cast( num2 as fltp ) as ratio,
          div( num1, num2 ) as div,
          mod( num1, num2 ) as mod,
*          @offset + abs( num1 - num2 ) as sum,
          case when num1 > num2 then 'X' end as bigger
          where concat( char1,char2 ) = 'duh'
*          order by sum descending
          into table @data(results).
