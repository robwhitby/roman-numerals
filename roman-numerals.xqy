xquery version '1.0-ml';
module namespace roman = 'http://github.com/robwhitby/roman-numerals';

declare variable $romans := ('I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C', 'CD', 'D', 'CM', 'M');    
declare variable $decimals := (1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);

declare function roman:to-integer($roman-numeral as xs:string) as xs:integer 
{     
	let $ints-reversed := 
    for $cp in fn:reverse(fn:string-to-codepoints($roman-numeral)) 
    return $decimals[fn:index-of($romans, fn:codepoints-to-string($cp))]
	return 
    if (fn:count($ints-reversed) ne fn:string-length($roman-numeral) or fn:count($ints-reversed) eq 0)
    then roman:invalid-roman()
    else
      fn:sum(
        for $int at $i in $ints-reversed
        return if ($ints-reversed[$i - 1] gt $int) then $int * -1 else $int 
      )
};

declare function roman:to-roman($int as xs:integer) as xs:string?
{
  if ($int gt 3999 or $int lt 1) then roman:unsupported-integer()
  else roman:recurse-int($int, (), fn:count($decimals))
};

declare private function roman:recurse-int($remainder as xs:int, $roman as xs:string?, $idx as xs:integer) as xs:string
{
  if ($remainder eq 0) then $roman
  else if ($decimals[$idx] gt $remainder) then roman:recurse-int($remainder, $roman, $idx - 1)
  else roman:recurse-int($remainder - $decimals[$idx], fn:concat($roman, $romans[$idx]), $idx)
};

declare private function roman:unsupported-integer() { fn:error(xs:QName("ROMAN-UNSUPPORTED-INTEGER"), "Integers outside the range 1 to 3999 are not supported") };
declare private function roman:invalid-roman() { fn:error(xs:QName("ROMAN-INVALID-ROMAN-NUMERAL"), "Invalid roman numeral") };
