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
$color = blue
body
  color: $color
```
Compile to:
```css
body {
  color: blue;
}
```
