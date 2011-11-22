xquery version '1.0-ml';
module namespace test = 'http://github.com/robwhitby/xray/test';
import module namespace assert = 'http://github.com/robwhitby/xray/assertions' at '/xray/src/assertions.xqy';

import module namespace roman = 'http://github.com/robwhitby/roman-numerals' at '/roman-numerals.xqy';


declare function test:throw-error-for-invalid-roman-numerals() 
{
  for $roman in ('', ' ', '5', 'Xi', 'Iz')
  let $result :=  
    try { roman:to-integer($roman) } 
    catch($err) { $err }
  return assert:error($result, "ROMAN-INVALID-ROMAN-NUMERAL")
};

declare function test:convert-single-character-roman-numerals()
{
  assert:equal(roman:to-integer('I'), 1),
  assert:equal(roman:to-integer('V'), 5),
  assert:equal(roman:to-integer('X'), 10),
  assert:equal(roman:to-integer('L'), 50),
  assert:equal(roman:to-integer('C'), 100),
  assert:equal(roman:to-integer('D'), 500),
  assert:equal(roman:to-integer('M'), 1000)
};

declare function test:convert-roman-numers-without-subtraction() 
{
  assert:equal(roman:to-integer('II'), 2),
  assert:equal(roman:to-integer('III'), 3),
  assert:equal(roman:to-integer('VII'), 7),
  assert:equal(roman:to-integer('XXI'), 21),
  assert:equal(roman:to-integer('XX'), 20),
  assert:equal(roman:to-integer('XX'), 20),
  assert:equal(roman:to-integer('XX'), 20),
  assert:equal(roman:to-integer('MMDCCCLXXVII'), 2877)
};

declare function test:convert-roman-numbers-with-subtraction() 
{
  assert:equal(roman:to-integer('IV'), 4),
  assert:equal(roman:to-integer('XL'), 40),
  assert:equal(roman:to-integer('CXCII'), 192),
  assert:equal(roman:to-integer('MCMLXXVIII'), 1978)
};

declare function test:convert-int-to-roman-numeral() 
{
  assert:equal(roman:to-roman(1), 'I'),
  assert:equal(roman:to-roman(3), 'III'),
  assert:equal(roman:to-roman(4), 'IV'),
  assert:equal(roman:to-roman(9), 'IX'),
  assert:equal(roman:to-roman(192), 'CXCII'),
  assert:equal(roman:to-roman(1978), 'MCMLXXVIII')   
};

declare function test:throw-error-for-invalid-integers() 
{
  for $int in (0, -1, 4000, 10000000)
  let $result :=  
    try { roman:to-roman($int) } 
    catch($err) { $err }
  return assert:error($result, "ROMAN-UNSUPPORTED-INTEGER")
};


