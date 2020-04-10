/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_SINT_H_INCLUDED
# define YY_YY_SINT_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    AUTO = 258,
    PAUSA = 259,
    CASO = 260,
    CHAR = 261,
    CONST = 262,
    CONTINUE = 263,
    DEFAULT = 264,
    FACA = 265,
    DOUBLE = 266,
    SENAO = 267,
    ENUM = 268,
    EXTERN = 269,
    FLOAT = 270,
    PARA = 271,
    GOTO = 272,
    SE = 273,
    INT = 274,
    LONG = 275,
    REGISTER = 276,
    RETORNE = 277,
    SHORT = 278,
    SIGNED = 279,
    SIZEOF = 280,
    STATIC = 281,
    STRUCT = 282,
    ESCOLHA = 283,
    TYPEDEF = 284,
    UNION = 285,
    UNSIGNED = 286,
    VOID = 287,
    VOLATILE = 288,
    ENQUANTO = 289,
    ID = 290,
    NUM = 291,
    MAIORIGUAL = 292,
    MENORIGUAL = 293,
    COMPARACAO = 294,
    DIFERENCA = 295,
    STRING = 296,
    OR = 297,
    AND = 298,
    NOT = 299
  };
#endif
/* Tokens.  */
#define AUTO 258
#define PAUSA 259
#define CASO 260
#define CHAR 261
#define CONST 262
#define CONTINUE 263
#define DEFAULT 264
#define FACA 265
#define DOUBLE 266
#define SENAO 267
#define ENUM 268
#define EXTERN 269
#define FLOAT 270
#define PARA 271
#define GOTO 272
#define SE 273
#define INT 274
#define LONG 275
#define REGISTER 276
#define RETORNE 277
#define SHORT 278
#define SIGNED 279
#define SIZEOF 280
#define STATIC 281
#define STRUCT 282
#define ESCOLHA 283
#define TYPEDEF 284
#define UNION 285
#define UNSIGNED 286
#define VOID 287
#define VOLATILE 288
#define ENQUANTO 289
#define ID 290
#define NUM 291
#define MAIORIGUAL 292
#define MENORIGUAL 293
#define COMPARACAO 294
#define DIFERENCA 295
#define STRING 296
#define OR 297
#define AND 298
#define NOT 299

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 1 "sint.y" /* yacc.c:1909  */

   struct  no3{
      int place;
      char *code;
      int len;
   }node;

#line 150 "sint.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SINT_H_INCLUDED  */
