xss
===

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
The variable start with ```$```
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
```+```:

