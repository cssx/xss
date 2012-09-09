XSS
===

[https://secure.travis-ci.org/cssx/xss.png]
[![Build Status](https://secure.travis-ci.org/cssx/xss.png)](http://travis-ci.org/cssx/xss)

## 1. Selectors
### 1.1 Indentation
```css
body
  background: #ccc
  .navbar
    position: fixed
    top: 0
```
Compile to:
```css
body {
  background: #ccc;
}
body .navbar {
  position: fixed;
  top: 0;
}
```
### 1.2 Rule Sets
```css
.foo, .bar
  color: #999
```
Compile to:
```css
.foo,
.bar {
  color: #999;
}
```

## 2. Variables
The variable start with `$`
```css
$padding = 10px
$margin-top = 5px
$margin-bottom = 10px
$margin = $margin-top 0 $margin-bottom 0
.foo
  padding: $padding
  margin: $margin
```
Compile to:
```css
.foo {
  padding: 10px;
  margin: 5px 0 10px 0;
}
```

## 3. Operators
### 3.1 Arithmetic Operators
+ `+`: `2px + 3` will give `5px`
+ `-`: `2px - 3` will give `-1px`
+ `*`: `2px * 3` will give `6px`
+ `/`: `2px / 3` will give `0.6666666666666666px`
+ `%`
+ `**`

### 3.2 Comparison Operators
`==`, `!=`, `>`, `<`, `>=`, `<=`, `<=>`

### 3.3 Assignment Operators
`=`, `+=`, `-=`, `*=`, `/=`, `%=`, `**=`

### 3.4 Parallel Assignment
+ `a, b, c = 1, 2, 3`
+ `a, b = b, c`
 
### 3.5 Bitwise Operators
`&`, `|`, `^`, `~`, `<<`, `>>`
 
### 3.6 Logical Operators
`&&`, `||`, `!`
 
### 3.7 Ternary operator
`?:`

### 3.8 Range operators
`..`, `...`
 
### 3.9 defined? operators
