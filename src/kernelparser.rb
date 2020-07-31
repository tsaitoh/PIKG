#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.16
# from Racc grammar file "".
#

require 'racc/parser.rb'

$lines = []
$used_q = []
def get_lineno(token)
  nline = 0
  $used_q.each{ |t|
    nline += 1 if t[0] == :EOL
    break if t[1] == token
  }
  $lines[nline][0]
end

def get_line(token)
  nline = 0
  $used_q.each{ |t|
    nline += 1 if t[0] == :EOL
    break if t[1] == token
  }
  $lines[nline][1]
end

class KernelParser < Racc::Parser

module_eval(<<'...end kernelparser.y/module_eval...', 'kernelparser.y', 152)
def vartype(string)
[[:F64VEC,:F64,:F32VEC,:F32,:F16VEC,:F16,:S64,:U64,:S32,:U32,:S16,:U16][["F64vec","F64","F32vec","F32","F16vec","F16","S64","U64","S32","U32","S16","U16"].index(string)],string]
end
def iotype(string)
[[:EPI,:EPJ,:FORCE,:MEMBER,:ACCUM,:TABLE][["EPI","EPJ","FORCE","MEMBER","ACCUM","TABLE"].index(string)], string]
end
def dim(string)
  [[:x,:y,:z,:xx,:yy,:zz,:xy,:xz,:yz,:yx,:zx,:zy][["x","y","z","xx","yy","zz","xy","xz","yz","yx","zx","zy"].index(string)],string]
end

def parse(filename)
  @q=[]
  open(filename){ |f|
    count = 0
    f.each_line{|str|
      a=str.chomp.split(/(\s|:|\=\=|\!\=|\+\=|-\=|\*\=|\&\&|\|\||\&|\||\+|-|\*|\/|\=|\(|\)|,|\.|>\=|<\=|>|<|\[|\]|;|~|\^)/).select{|s| s=~/\S+/}
      symbols = /(\=\=|\!\=|\&\&|\|\||\&|\||\+|-|\*|\/|\(|\)|,|\.|>\=|<\=|>|<|\[|\]|\{|\})/
      if a == []
        next
      end
      count += 1
      $lines.push([count,str])
      if a[0] =~ /(EPI|EPJ|FORCE|MEMBER|ACCUM|TABLE)/
        io = a[0]
        @q << iotype(a.shift) # iotype
      end
      if a[0] == "static"
        @q << ["static",a.shift]
      elsif a[0] == "local"
        @q << ["local",a.shift]
      end

      if a[0] =~ /(F(64|32|16)|F(64|32|16)vec|(U|S)(64|32|16))/
        @q << vartype(a.shift) # type
        @q << [:IDENT, a.shift] # varname
        if io != nil && a[0] == ":"
          @q << [":",a.shift] # :
          @q << [:IDENT, a.shift] # fdpsname
        end
      elsif a[0] == "function"
        #      print "function decl"
        @q << ["function", a.shift]
        @q << [:IDENT, a.shift]
        @q << ["(", a.shift]
        a.each{|x|
          if x =~ /(F(64|32|16)|F(64|32|16)vec|(U|S)(64|32|16))/
            @q << vartype(x)
          elsif x  == ','
            @q << [',', x]
          elsif x  == ')'
            @q << [')', x]
          else
            @q << [:IDENT, x]
          end
        }
      elsif a[0] == "return"
        @q << ["return", a.shift]
        a.each{ |x|
          if x =~ symbols
            @q << [x, x]
	  elsif x =~ /^\d+(f|h|s|l|u|us|ul)?$/
            @q << [:DEC, x]
          else
            @q << [:IDENT, x]
          end
        }
      elsif a[0] == "end"
        @q << ["end", a.shift]
      elsif a[0] == "#pragma"
        #p a
        @q << ["#pragma",a.shift]
        a.each{|x|
	  @q << [:TEXT,x]
        }
      elsif a[0] == "if"
        @q << ["if","if"]
        a.shift
        a.each{|x|
	  if x =~ symbols
	    @q << [x,x]
	  elsif x =~ /^\d+(f|h|s|l|u|us|ul)?$/
            @q << [:DEC, x]
          else
            @q << [:IDENT, x]
	  end
        }
      elsif a[0] == "elsif"
        @q << ["elsif","elsif"]
        a.shift
        a.each{|x|
	  if x =~ symbols
	    @q << [x,x]
	  elsif x =~ /^\d+(f|h|s|l|u|us|ul)?$/
	    @q << [:DEC, x]
	  else
            @q << [:IDENT, x]
	  end
        }
      elsif a[0] == "else"
        @q << ["else","else"]
      elsif a[0] == "endif"
        @q << ["endif","endif"]
      elsif a[1] =~ /(\=|\+\=|-\=)/
        #print "statement \n"
        @q << [:IDENT,a.shift]
        #p a
        @q << [a[0], a[0]]
        a.shift
        a.each{|x|
          if x =~ symbols
            @q << [x,x]
	  elsif x =~/^\d+(f|h|s|l|u|us|ul)?$/
            @q << [:DEC,x]
          else
            @q << [:IDENT,x]
          end
        }
      elsif a[3] =~ /(\=|\+\=|-\=)/
        #print "statement \n"
        @q << [:IDENT,a.shift] # var
        @q << [a[0], a[0]]    #.
        a.shift
        @q << [:IDENT,a.shift]
        @q << [a[0], a[0]]    # =|+=|-=|*=|/=
        a.shift
        a.each{|x|
          if x =~ symbols
            @q << [x,x]
	  elsif x =~/^\d+(f|h|s|l|u|us|ul)?$/
            @q << [:DEC,x]
          else
            @q << [:IDENT,x]
          end
        }
      else
        warn "error: unsupported DSL description"
        warn "  line #{f.lineno}: #{str}"
        abort
      end
      @q << [:EOL,:EOL]
    }
    @q << nil
    do_parse
  }
end

def next_token
  tmp = @q.shift
  $used_q << tmp
  tmp
end


def on_error(id,val,stack)
  lineno = get_lineno(val)
  line   = get_line(val)
  warning = "parse error :line #{lineno}: #{line}"
  for i in 1..warning.index(val)
    warning += " "
  end
  warning += "^"
  abort warning
end
...end kernelparser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    78,    71,    71,    64,    98,    99,    96,    97,    98,    99,
    38,    64,   172,    64,    23,    64,    45,    64,    46,    64,
   165,    64,    29,    66,    62,    64,    52,   112,    64,    59,
    64,    66,    62,    66,    62,    66,    62,    66,    62,    66,
    62,    66,    62,    40,    67,    66,    62,   164,    66,    62,
    66,    62,    98,    99,    69,    64,    40,    72,    72,    73,
    74,    75,    76,    77,    40,    64,    40,    64,    40,    64,
    40,    64,    40,    64,    40,    66,    62,    64,    40,    64,
    70,    40,    64,    40,    64,    66,    62,    66,    62,    66,
    62,    66,    62,    66,    62,    64,    45,    66,    62,    66,
    62,    82,    66,    62,    66,    62,    51,    64,    40,    98,
    99,    96,    97,   166,   165,    66,    62,    85,    40,    64,
    40,    64,    40,    64,    40,    64,    40,    66,    62,    64,
    40,    87,    40,    90,    95,    40,   113,    40,   116,    66,
    62,    66,    62,    66,    62,    66,    62,   117,    40,    66,
    62,    98,    99,    96,    97,   162,   163,   119,    51,   120,
    40,    38,    98,    99,    96,    97,   107,   106,   109,   108,
   102,   103,    40,    45,    40,    45,    40,    85,    40,   156,
   157,   124,    40,   125,    33,    34,    35,    36,    37,    45,
    29,    38,   129,   130,    40,     7,     8,     9,    10,    11,
    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,
    22,    38,    55,    56,    33,    34,    35,    36,    37,   134,
   135,   136,    38,   137,    40,    98,    99,    96,    97,   107,
   106,   109,   108,   116,    33,    34,    35,    36,    37,   155,
   159,    54,    57,    58,    40,    33,    34,    35,    36,    37,
    98,    99,    96,    97,   160,    40,    98,    99,    96,    97,
   107,   106,   109,   108,   102,   103,   100,   101,   104,   105,
    42,    43,    98,    99,    96,    97,   107,   106,   109,   108,
   161,   152,   167,    11,    12,    13,    14,    15,    16,    17,
    18,    19,    20,    21,    22,     7,     8,     9,    10,    11,
    12,    13,    14,    15,    16,    17,    18,    19,    20,    21,
    22,    98,    99,    96,    97,   107,   106,   109,   108,   102,
   103,   100,   101,   104,   105,    98,    99,    96,    97,   107,
   106,   109,   108,   102,   103,   100,   101,   104,   105,    98,
    99,    96,    97,   107,   106,   109,   108,   102,   103,   100,
   101,    11,    12,    13,    14,    15,    16,    17,    18,    19,
    20,    21,    22,    11,    12,    13,    14,    15,    16,    17,
    18,    19,    20,    21,    22,    98,    99,    96,    97,   107,
   106,   109,   108,   102,   103,   100,   101,    98,    99,    96,
    97,   107,   106,   109,   108,   102,   103,   159,   169,    45 ]

racc_action_check = [
    40,    66,    38,   101,   151,   151,   151,   151,   139,   139,
    72,   102,   168,   103,     1,   104,     6,   105,    23,   106,
   132,   107,    27,   101,   101,   108,    29,    66,   109,    32,
   112,   102,   102,   103,   103,   104,   104,   105,   105,   106,
   106,   107,   107,    72,    34,   108,   108,   132,   109,   109,
   112,   112,   138,   138,    36,    98,   101,    66,    38,    40,
    40,    40,    40,    40,   102,    62,   103,    64,   104,    35,
   105,    99,   106,   100,   107,    98,    98,   165,   108,    33,
    37,   109,    51,   112,    54,    62,    62,    64,    64,    35,
    35,    99,    99,   100,   100,    90,    41,   165,   165,    33,
    33,    44,    51,    51,    54,    54,    49,    55,    98,   150,
   150,   150,   150,   153,   153,    90,    90,    50,    62,    56,
    64,    57,    35,    58,    99,    96,   100,    55,    55,    97,
   165,    52,    33,    54,    60,    51,    68,    54,    70,    56,
    56,    57,    57,    58,    58,    96,    96,    71,    90,    97,
    97,   149,   149,   149,   149,   126,   126,    78,    28,    79,
    55,    28,   143,   143,   143,   143,   143,   143,   143,   143,
   143,   143,    56,    80,    57,    81,    58,    83,    96,   119,
   119,    85,    97,    86,    28,    28,    28,    28,    28,    87,
     2,     2,    88,    89,    28,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,    24,    31,    31,     2,     2,     2,     2,     2,    91,
    92,    93,    30,    94,     2,   145,   145,   145,   145,   145,
   145,   145,   145,   114,    24,    24,    24,    24,    24,   118,
   120,    31,    31,    31,    24,    30,    30,    30,    30,    30,
   148,   148,   148,   148,   121,    30,   110,   110,   110,   110,
   110,   110,   110,   110,   110,   110,   110,   110,   110,   110,
     4,     4,   144,   144,   144,   144,   144,   144,   144,   144,
   122,   110,   158,     4,     4,     4,     4,     4,     4,     4,
     4,     4,     4,     4,     4,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,    61,    61,    61,    61,    61,    61,    61,    61,    61,
    61,    61,    61,    61,    61,   131,   131,   131,   131,   131,
   131,   131,   131,   131,   131,   131,   131,   131,   131,   146,
   146,   146,   146,   146,   146,   146,   146,   146,   146,   146,
   146,    42,    42,    42,    42,    42,    42,    42,    42,    42,
    42,    42,    42,    43,    43,    43,    43,    43,    43,    43,
    43,    43,    43,    43,    43,   147,   147,   147,   147,   147,
   147,   147,   147,   147,   147,   147,   147,   142,   142,   142,
   142,   142,   142,   142,   142,   142,   142,   160,   162,   163 ]

racc_action_pointer = [
   264,    14,   164,   nil,   248,   nil,   -11,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    18,   184,   nil,   nil,    -4,   134,    -1,
   195,   194,     8,    72,    23,    62,    33,    25,     0,   nil,
    -2,    69,   316,   328,    80,   nil,   nil,   nil,   nil,    82,
    92,    75,   103,   nil,    77,   100,   112,   114,   116,   nil,
   113,   307,    58,   nil,    60,   nil,    -1,   nil,   115,   nil,
    83,   120,   -17,   nil,   nil,   nil,   nil,   nil,    97,   139,
   146,   148,   nil,   152,   nil,   160,   162,   162,   171,   172,
    88,   198,   199,   200,   202,   nil,   118,   122,    48,    64,
    66,    -4,     4,     6,     8,    10,    12,    14,    18,    21,
   252,   nil,    23,   nil,   178,   nil,   nil,   nil,   180,   113,
   213,   234,   259,   nil,   nil,   nil,   126,   nil,   nil,   nil,
   nil,   321,   -10,   nil,   nil,   nil,   nil,   nil,    48,     4,
   nil,   nil,   383,   158,   268,   221,   335,   371,   246,   147,
   105,     0,   nil,    84,   nil,   nil,   nil,   nil,   261,   nil,
   370,   nil,   377,   372,   nil,    70,   nil,   nil,    -9,   nil,
   nil,   nil,   nil ]

racc_action_default = [
   -93,   -93,   -93,    -3,   -93,    -8,   -93,   -20,   -21,   -22,
   -23,   -24,   -25,   -26,   -27,   -28,   -29,   -30,   -31,   -32,
   -33,   -34,   -35,   -93,   -93,    -2,    -4,    -9,   -93,   -93,
   -38,   -93,   -93,   -93,   -93,   -93,   -93,   -93,   -80,   -83,
   -84,   -93,   -93,   -93,   -93,   -36,   173,    -1,   -10,   -93,
   -93,   -93,   -93,   -39,   -93,   -93,   -93,   -93,   -93,   -46,
   -93,   -56,   -93,   -72,   -93,   -74,   -80,   -48,   -93,   -50,
   -51,   -93,   -93,   -85,   -86,   -87,   -88,   -89,   -93,   -93,
   -93,   -93,   -19,   -93,   -12,   -93,   -93,   -93,   -93,   -93,
   -93,   -93,   -93,   -93,   -93,   -47,   -93,   -93,   -93,   -93,
   -93,   -93,   -93,   -93,   -93,   -93,   -93,   -93,   -93,   -93,
   -93,   -73,   -93,   -49,   -52,   -53,   -55,   -81,   -93,   -90,
   -93,   -93,   -93,   -11,   -14,   -13,   -93,   -16,   -18,   -40,
   -41,   -79,   -93,   -77,   -42,   -43,   -44,   -45,   -57,   -58,
   -59,   -60,   -61,   -62,   -63,   -64,   -65,   -66,   -67,   -68,
   -69,   -70,   -71,   -93,   -54,   -82,   -91,   -92,   -93,   -37,
   -93,    -7,   -93,   -93,   -75,   -93,   -76,    -5,   -93,   -15,
   -17,   -78,    -6 ]

racc_goto_table = [
   110,   127,   111,    31,    25,   115,    50,     3,    24,    26,
   171,   158,     2,    44,    41,   126,    89,   114,     1,   nil,
   nil,    84,   nil,   nil,   nil,    31,    47,    83,   131,    31,
    49,    31,    53,    48,   138,   139,   140,   141,   142,   143,
   144,   145,   146,   147,   148,   149,   150,   151,    79,   154,
   131,   168,    80,    81,   123,   nil,   nil,    60,   nil,    68,
   nil,   132,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   118,   nil,    86,   nil,   170,    88,    91,
    92,    93,    94,   153,   nil,   nil,   nil,   121,   122,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   131 ]

racc_goto_check = [
    24,    17,    24,    19,     4,    23,    13,     5,     3,     5,
    27,     9,     2,     8,     7,    16,    20,    22,     1,   nil,
   nil,    14,   nil,   nil,   nil,    19,     4,    13,    24,    19,
     4,    19,     4,     3,    24,    24,    24,    24,    24,    24,
    24,    24,    24,    24,    24,    24,    24,    24,     8,    23,
    24,     9,     7,     7,    14,   nil,   nil,    15,   nil,    15,
   nil,    26,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    19,   nil,    15,   nil,    17,    15,    15,
    15,    15,    15,    26,   nil,   nil,   nil,     8,     8,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    24 ]

racc_goto_pointer = [
   nil,    18,    12,     6,     2,     7,   nil,    10,     7,  -109,
   nil,   nil,   nil,   -22,   -29,    24,   -72,   -86,   nil,     1,
   -38,   nil,   -53,   -65,   -62,   nil,   -29,  -155,   nil ]

racc_goto_default = [
   nil,   nil,   nil,   nil,   nil,   nil,     4,     6,   128,   nil,
     5,    27,    28,   nil,   nil,   nil,   nil,   nil,    30,    65,
   nil,    32,   nil,   nil,    61,    63,   nil,   133,    39 ]

racc_reduce_table = [
  0, 0, :racc_error,
  3, 69, :_reduce_1,
  2, 69, :_reduce_2,
  1, 70, :_reduce_none,
  2, 70, :_reduce_4,
  6, 73, :_reduce_5,
  7, 73, :_reduce_6,
  5, 73, :_reduce_7,
  1, 73, :_reduce_none,
  1, 71, :_reduce_none,
  2, 71, :_reduce_10,
  4, 79, :_reduce_11,
  3, 79, :_reduce_12,
  3, 81, :_reduce_13,
  2, 82, :_reduce_none,
  6, 80, :_reduce_15,
  1, 84, :_reduce_none,
  3, 84, :_reduce_17,
  1, 85, :_reduce_18,
  3, 78, :_reduce_19,
  1, 74, :_reduce_none,
  1, 74, :_reduce_none,
  1, 74, :_reduce_none,
  1, 74, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 76, :_reduce_none,
  1, 77, :_reduce_none,
  1, 72, :_reduce_none,
  2, 72, :_reduce_39,
  4, 86, :_reduce_40,
  4, 86, :_reduce_41,
  4, 86, :_reduce_42,
  4, 86, :_reduce_43,
  4, 86, :_reduce_44,
  4, 86, :_reduce_45,
  2, 86, :_reduce_46,
  3, 86, :_reduce_47,
  2, 86, :_reduce_48,
  3, 86, :_reduce_49,
  2, 86, :_reduce_50,
  2, 89, :_reduce_51,
  3, 89, :_reduce_52,
  1, 90, :_reduce_53,
  2, 90, :_reduce_54,
  1, 91, :_reduce_55,
  1, 83, :_reduce_none,
  3, 92, :_reduce_57,
  3, 92, :_reduce_58,
  3, 92, :_reduce_59,
  3, 92, :_reduce_60,
  3, 92, :_reduce_61,
  3, 92, :_reduce_62,
  3, 92, :_reduce_63,
  3, 92, :_reduce_64,
  3, 92, :_reduce_65,
  3, 92, :_reduce_66,
  3, 92, :_reduce_67,
  3, 92, :_reduce_68,
  3, 92, :_reduce_69,
  3, 92, :_reduce_70,
  3, 92, :_reduce_71,
  1, 92, :_reduce_72,
  2, 92, :_reduce_73,
  1, 92, :_reduce_none,
  3, 88, :_reduce_75,
  4, 93, :_reduce_76,
  1, 94, :_reduce_none,
  3, 94, :_reduce_78,
  1, 95, :_reduce_79,
  1, 87, :_reduce_80,
  3, 87, :_reduce_81,
  4, 87, :_reduce_82,
  1, 87, :_reduce_none,
  1, 96, :_reduce_84,
  2, 96, :_reduce_85,
  2, 96, :_reduce_86,
  2, 96, :_reduce_87,
  2, 96, :_reduce_88,
  2, 96, :_reduce_89,
  3, 96, :_reduce_90,
  4, 96, :_reduce_91,
  4, 96, :_reduce_92 ]

racc_reduce_n = 93

racc_shift_n = 173

racc_token_table = {
  false => 0,
  :error => 1,
  "." => 2,
  :UMINUS => 3,
  "*" => 4,
  "/" => 5,
  "+" => 6,
  "-" => 7,
  "<" => 8,
  ">" => 9,
  "<=" => 10,
  ">=" => 11,
  "&" => 12,
  "|" => 13,
  "==" => 14,
  "!=" => 15,
  "&&" => 16,
  "||" => 17,
  "+=" => 18,
  "-=" => 19,
  ":" => 20,
  :EOL => 21,
  "static" => 22,
  "local" => 23,
  "return" => 24,
  "end" => 25,
  "function" => 26,
  :IDENT => 27,
  "(" => 28,
  ")" => 29,
  "," => 30,
  :EPI => 31,
  :EPJ => 32,
  :FORCE => 33,
  :TABLE => 34,
  :F64VEC => 35,
  :F64 => 36,
  :F32VEC => 37,
  :F32 => 38,
  :F16VEC => 39,
  :F16 => 40,
  :S64 => 41,
  :U64 => 42,
  :S32 => 43,
  :U32 => 44,
  :S16 => 45,
  :U16 => 46,
  "=" => 47,
  "*=" => 48,
  "/=" => 49,
  "if" => 50,
  "else" => 51,
  "elsif" => 52,
  "endif" => 53,
  "#pragma" => 54,
  :TEXT => 55,
  "{" => 56,
  "}" => 57,
  "[" => 58,
  "]" => 59,
  :DEC => 60,
  "l" => 61,
  "s" => 62,
  "u" => 63,
  "ul" => 64,
  "us" => 65,
  "f" => 66,
  "h" => 67 }

racc_nt_base = 68

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "\".\"",
  "UMINUS",
  "\"*\"",
  "\"/\"",
  "\"+\"",
  "\"-\"",
  "\"<\"",
  "\">\"",
  "\"<=\"",
  "\">=\"",
  "\"&\"",
  "\"|\"",
  "\"==\"",
  "\"!=\"",
  "\"&&\"",
  "\"||\"",
  "\"+=\"",
  "\"-=\"",
  "\":\"",
  "EOL",
  "\"static\"",
  "\"local\"",
  "\"return\"",
  "\"end\"",
  "\"function\"",
  "IDENT",
  "\"(\"",
  "\")\"",
  "\",\"",
  "EPI",
  "EPJ",
  "FORCE",
  "TABLE",
  "F64VEC",
  "F64",
  "F32VEC",
  "F32",
  "F16VEC",
  "F16",
  "S64",
  "U64",
  "S32",
  "U32",
  "S16",
  "U16",
  "\"=\"",
  "\"*=\"",
  "\"/=\"",
  "\"if\"",
  "\"else\"",
  "\"elsif\"",
  "\"endif\"",
  "\"#pragma\"",
  "TEXT",
  "\"{\"",
  "\"}\"",
  "\"[\"",
  "\"]\"",
  "DEC",
  "\"l\"",
  "\"s\"",
  "\"u\"",
  "\"ul\"",
  "\"us\"",
  "\"f\"",
  "\"h\"",
  "$start",
  "innerkernel",
  "iodeclarations",
  "functions",
  "statements",
  "iodeclaration",
  "iotype",
  "type",
  "varname",
  "fdpsname",
  "declaration",
  "function",
  "funcdeclaration",
  "ret_state",
  "end_state",
  "expression",
  "operands",
  "operand",
  "statement",
  "var",
  "table",
  "pragma",
  "options",
  "option",
  "binary",
  "funccall",
  "args",
  "arg",
  "number" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'kernelparser.y', 18)
  def _reduce_1(val, _values, result)
    result=Kernelprogram.new(val)
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 19)
  def _reduce_2(val, _values, result)
    result=Kernelprogram.new(val)
    result
  end
.,.,

# reduce 3 omitted

module_eval(<<'.,.,', 'kernelparser.y', 21)
  def _reduce_4(val, _values, result)
    result = val[0]+val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 22)
  def _reduce_5(val, _values, result)
    result = [Iodeclaration.new([val[0],val[1],val[2],val[4],nil])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 23)
  def _reduce_6(val, _values, result)
    result = [Iodeclaration.new([val[0],val[2],val[3],val[5],"static"])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 24)
  def _reduce_7(val, _values, result)
     result = [Iodeclaration.new([val[0],val[2],val[3],nil,"local"])]
    result
  end
.,.,

# reduce 8 omitted

# reduce 9 omitted

module_eval(<<'.,.,', 'kernelparser.y', 28)
  def _reduce_10(val, _values, result)
    result = val[0]+val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 29)
  def _reduce_11(val, _values, result)
    result = [Function.new([val[0],val[1],val[2]])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 30)
  def _reduce_12(val, _values, result)
    result = [Function.new([val[0],[],val[1]])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 31)
  def _reduce_13(val, _values, result)
    result = ReturnState.new(val[1])
    result
  end
.,.,

# reduce 14 omitted

module_eval(<<'.,.,', 'kernelparser.y', 33)
  def _reduce_15(val, _values, result)
    result = Funcdeclaration.new([val[1],val[3]])
    result
  end
.,.,

# reduce 16 omitted

module_eval(<<'.,.,', 'kernelparser.y', 36)
  def _reduce_17(val, _values, result)
    result = val[0] + val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 37)
  def _reduce_18(val, _values, result)
    result = [val[0]]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 39)
  def _reduce_19(val, _values, result)
    result = [Iodeclaration.new(["MEMBER",val[0],val[1],nil,nil])]
    result
  end
.,.,

# reduce 20 omitted

# reduce 21 omitted

# reduce 22 omitted

# reduce 23 omitted

# reduce 24 omitted

# reduce 25 omitted

# reduce 26 omitted

# reduce 27 omitted

# reduce 28 omitted

# reduce 29 omitted

# reduce 30 omitted

# reduce 31 omitted

# reduce 32 omitted

# reduce 33 omitted

# reduce 34 omitted

# reduce 35 omitted

# reduce 36 omitted

# reduce 37 omitted

# reduce 38 omitted

module_eval(<<'.,.,', 'kernelparser.y', 64)
  def _reduce_39(val, _values, result)
    result = val[0]+val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 66)
  def _reduce_40(val, _values, result)
    result = [Statement.new([val[0],val[2]])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 67)
  def _reduce_41(val, _values, result)
    result = [TableDecl.new([val[0],val[2]])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 68)
  def _reduce_42(val, _values, result)
    result = [Statement.new([val[0],Expression.new([:plus, val[0], val[2]])])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 69)
  def _reduce_43(val, _values, result)
    result = [Statement.new([val[0],Expression.new([:minus,val[0], val[2]])])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 70)
  def _reduce_44(val, _values, result)
    result = [Statement.new([val[0],Expression.new([:mult,val[0], val[2]])])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 71)
  def _reduce_45(val, _values, result)
    result = [Statement.new([val[0],Expression.new([:div,val[0], val[2]])])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 72)
  def _reduce_46(val, _values, result)
    result = [val[0]]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 73)
  def _reduce_47(val, _values, result)
    result = [IfElseState.new([:if,val[1]])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 74)
  def _reduce_48(val, _values, result)
    result = [IfElseState.new([:else,nil])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 75)
  def _reduce_49(val, _values, result)
    result = [IfElseState.new([:elsif,val[1]])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 76)
  def _reduce_50(val, _values, result)
    result = [IfElseState.new([:endif,nil])]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 78)
  def _reduce_51(val, _values, result)
    result = Pragma.new([val[1],nil])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 79)
  def _reduce_52(val, _values, result)
    result = Pragma.new([val[1],val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 80)
  def _reduce_53(val, _values, result)
     result = val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 81)
  def _reduce_54(val, _values, result)
     result = val[0] + val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 82)
  def _reduce_55(val, _values, result)
     result = [val[0]]
    result
  end
.,.,

# reduce 56 omitted

module_eval(<<'.,.,', 'kernelparser.y', 86)
  def _reduce_57(val, _values, result)
    result = Expression.new([:plus,  val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 87)
  def _reduce_58(val, _values, result)
    result = Expression.new([:minus, val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 88)
  def _reduce_59(val, _values, result)
    result = Expression.new([:mult,  val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 89)
  def _reduce_60(val, _values, result)
    result = Expression.new([:div,   val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 90)
  def _reduce_61(val, _values, result)
    result = Expression.new([:eq,    val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 91)
  def _reduce_62(val, _values, result)
    result = Expression.new([:neq,   val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 92)
  def _reduce_63(val, _values, result)
    result = Expression.new([:and,   val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 93)
  def _reduce_64(val, _values, result)
    result = Expression.new([:or,    val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 94)
  def _reduce_65(val, _values, result)
    result = Expression.new([:land,   val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 95)
  def _reduce_66(val, _values, result)
    result = Expression.new([:lor,    val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 96)
  def _reduce_67(val, _values, result)
    result = Expression.new([:gt,    val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 97)
  def _reduce_68(val, _values, result)
    result = Expression.new([:lt,    val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 98)
  def _reduce_69(val, _values, result)
    result = Expression.new([:ge,    val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 99)
  def _reduce_70(val, _values, result)
    result = Expression.new([:le,    val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 100)
  def _reduce_71(val, _values, result)
    result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 101)
  def _reduce_72(val, _values, result)
    result = val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 102)
  def _reduce_73(val, _values, result)
    result = Expression.new([:uminus,val[1], nil])
    result
  end
.,.,

# reduce 74 omitted

module_eval(<<'.,.,', 'kernelparser.y', 105)
  def _reduce_75(val, _values, result)
    result = Table.new(val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 107)
  def _reduce_76(val, _values, result)
    result = FuncCall.new([val[0], val[2]])
    result
  end
.,.,

# reduce 77 omitted

module_eval(<<'.,.,', 'kernelparser.y', 109)
  def _reduce_78(val, _values, result)
    result = val[0] + val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 110)
  def _reduce_79(val, _values, result)
    result = [val[0]]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 112)
  def _reduce_80(val, _values, result)
    result = val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 113)
  def _reduce_81(val, _values, result)
    result = Expression.new([:dot,val[0],val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 114)
  def _reduce_82(val, _values, result)
    result = Expression.new([:array,val[0],val[2]])
    result
  end
.,.,

# reduce 83 omitted

module_eval(<<'.,.,', 'kernelparser.y', 117)
  def _reduce_84(val, _values, result)
    result = IntegerValue.new(val[0])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 118)
  def _reduce_85(val, _values, result)
    result = IntegerValue.new(val[0]+val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 119)
  def _reduce_86(val, _values, result)
    result = IntegerValue.new(val[0]+val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 120)
  def _reduce_87(val, _values, result)
    result = IntegerValue.new(val[0]+val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 121)
  def _reduce_88(val, _values, result)
    result = IntegerValue.new(val[0]+val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 122)
  def _reduce_89(val, _values, result)
    result = IntegerValue.new(val[0]+val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 123)
  def _reduce_90(val, _values, result)
    result = FloatingPoint.new(val[0]+val[1]+val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 124)
  def _reduce_91(val, _values, result)
    result = FloatingPoint.new(val[0]+val[1]+val[2]+val[3])
    result
  end
.,.,

module_eval(<<'.,.,', 'kernelparser.y', 125)
  def _reduce_92(val, _values, result)
    result = FloatingPoint.new(val[0]+val[1]+val[2]+val[3])
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class KernelParser
